#include <filesystem>
#include <fstream>
#include <iostream>
#include <cstdlib>
#include <vector>
#include <string>
#include <random>
#include "taglib/fileref.h"
#include "taglib/tag.h"

namespace fs = std::filesystem;

std::string generate_serial() {
    std::string chars = "0123456789ABCDEF";
    std::string serial;
    std::random_device rd;
    std::mt19937 gen(rd());
    for (int i = 0; i < 16; ++i)
        serial += chars[gen() % chars.length()];
    return serial;
}

void write_prefs(const fs::path& path, const std::string& name, const std::string& serial) {
    std::ofstream out(path);
    out << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        << "<plist version=\"1.0\">\n"
        << "<dict>\n"
        << "<key>iPodSerialNumber</key><string>" << serial << "</string>\n"
        << "<key>DeviceName</key><string>" << name << "</string>\n"
        << "<key>ModelIdentifier</key><string>iPod2,1</string>\n"
        << "<key>ProductType</key><string>iPodShuffle</string>\n"
        << "</dict>\n"
        << "</plist>\n";
}

void copy_mp3s(const fs::path& src_dir, const fs::path& dest_dir) {
    int count = 0;
    for (auto& file : fs::directory_iterator(src_dir)) {
        if (file.path().extension() == ".mp3") {
            std::string subfolder = "F" + std::to_string((count / 100) % 99);
            fs::create_directories(dest_dir / subfolder);
            fs::copy(file.path(), dest_dir / subfolder / file.path().filename());
            count++;
        }
    }
}

void write_fake_itunesdb(const fs::path& db_path, int track_count) {
    std::ofstream db(db_path, std::ios::binary);
    db << "ITDB"; // Signature, real iPods use a full binary format — this is a stub
    for (int i = 0; i < track_count; ++i) {
        db << "FAKE_TRACK_" << i << "\n";
    }
}

void create_structure(const std::string& name, const fs::path& outdir, const fs::path& music_folder) {
    fs::path control = outdir / "iPod_Control";
    fs::create_directories(control / "Music");

    std::string serial = generate_serial();

    write_prefs(control / "iTunesPrefs.xml", name, serial);
    copy_mp3s(music_folder, control / "Music");
    write_fake_itunesdb(control / "iTunesDB", 100); // Placeholder count

    std::cout << "[✓] Structure ready: " << outdir << std::endl;
}

void make_iso(const fs::path& source_dir, const std::string& iso_out) {
    std::string cmd = "genisoimage -quiet -V IPOD -o " + iso_out + " " + source_dir.string();
    if (std::system(cmd.c_str()) == 0)
        std::cout << "[✓] ISO created: " << iso_out << "\n";
    else
        std::cerr << "[X] Failed to create ISO.\n";
}

void compress(const std::string& filename) {
    std::string cmd = "xz -z -f " + filename;
    if (std::system(cmd.c_str()) == 0)
        std::cout << "[✓] Compressed: " << filename << ".xz\n";
    else
        std::cerr << "[X] Compression failed.\n";
}

int main(int argc, char* argv[]) {
    if (argc < 5) {
        std::cerr << "Usage: iphony --input <mp3folder> --output <isoout> [--name <device name>] [--compress]\n";
        return 1;
    }

    std::string input_folder = argv[2];
    std::string output_file = argv[4];
    std::string name = "FakePod";
    bool do_compress = false;

    for (int i = 5; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--name" && i + 1 < argc) {
            name = argv[++i];
        } else if (arg == "--compress") {
            do_compress = true;
        }
    }

    fs::path tmpdir = fs::temp_directory_path() / "iphony_build";
    fs::remove_all(tmpdir);
    fs::create_directories(tmpdir);

    create_structure(name, tmpdir, input_folder);
    make_iso(tmpdir, output_file);

    if (do_compress)
        compress(output_file);

    return 0;
}
