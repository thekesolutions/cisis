# CISIS - Computerized Information System in Health

CISIS is a powerful database management system designed for bibliographic and documentary information, developed by BIREME/PAHO. It's widely used by libraries, research institutions, and information centers worldwide.

## What is CISIS?

CISIS helps you:
- **Manage bibliographic databases** (books, articles, documents)
- **Import/export** library catalogs in standard formats (MARC21, ISO 2709)
- **Search and retrieve** information with powerful query capabilities
- **Generate reports** and formatted outputs
- **Migrate data** between different library systems

## Quick Links

- **[📖 Usage Guide](USAGE.md)** - Complete guide with examples and tutorials
- **[🔧 Build Instructions](BUILD.md)** - Multi-platform compilation guide
- **[📚 Official Documentation](http://wiki.bireme.org/en/index.php/CISIS)** - BIREME wiki

## Getting Started

### Option 1: Download Pre-built Binaries (Recommended)
1. Go to [Releases](../../releases)
2. Download for your platform:
   - **Linux**: `cisis-linux-amd64.tar.gz` or `cisis-linux-arm64.tar.gz`
   - **macOS**: `cisis-darwin-amd64.tar.gz` (Intel) or `cisis-darwin-arm64.tar.gz` (Apple Silicon)
3. Extract and run: `./mx`

### Option 2: Build from Source
```bash
git clone <this-repository>
cd cisis
./generateApp64.sh
```

### Option 3: Docker
```bash
docker pull ghcr.io/username/cisis:latest
docker run --rm -v $(pwd):/data ghcr.io/username/cisis:latest
```

## Basic Usage

**View your database:**
```bash
./mx mydatabase from=1 count=10
```

**Search for records:**
```bash
./mx mydatabase "bool=cancer and therapy"
```

**Export to standard format:**
```bash
./mx mydatabase iso=backup.iso now
```

**Import from another system:**
```bash
./mx iso=catalog.iso create=mydatabase now
```

## Who Uses CISIS?

- **Libraries** - Catalog management and circulation
- **Universities** - Thesis and research databases  
- **Research Centers** - Scientific literature databases
- **Government Agencies** - Document management systems
- **Publishers** - Bibliographic control systems

## Key Features

✅ **Multi-format support** - MARC21, ISO 2709, Dublin Core  
✅ **Powerful search** - Boolean queries, field-specific searches  
✅ **Flexible output** - Custom reports and formats  
✅ **Cross-platform** - Linux, macOS, Windows  
✅ **Web interface** - Browser-based access with WXIS  
✅ **Migration tools** - Import/export between systems  

## File Formats Supported

| Format | Description | Use Case |
|--------|-------------|----------|
| **ISO 2709** | International standard | Library catalog exchange |
| **MARC21** | Machine-readable cataloging | Bibliographic records |
| **Text** | Delimited or formatted | Reports and exports |
| **XML** | Structured data | Web services and APIs |

## Common Use Cases

**Library Catalog:**
```bash
# Import MARC records
./mx iso=library-catalog.iso create=catalog now

# Search by author
./mx catalog "bool=shakespeare$" "pft='Title: 'v245^a"

# Generate shelf list
./mx catalog "pft=v082^a,x5,v245^a" lw=80 now > shelf-list.txt
```

**Database Migration:**
```bash
# Export from old system
./mx oldsystem iso=migration.iso now

# Import to new system  
./mx iso=migration.iso create=newsystem now
```

## Need Help?

- **[📖 Read the Usage Guide](USAGE.md)** - Step-by-step tutorials
- **[🔧 Build from Source](BUILD.md)** - Compilation instructions
- **[📚 Official Wiki](http://wiki.bireme.org/en/index.php/CISIS)** - Complete documentation
- **[💬 Community Support](../../discussions)** - Ask questions and share tips

## License

CISIS is developed by BIREME/PAHO and distributed under open source license. See LICENSE file for details.

---

*CISIS has been serving the library and information science community for over 30 years, helping manage millions of bibliographic records worldwide.*
