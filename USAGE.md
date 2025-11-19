# CISIS Usage Guide

CISIS (Computerized Information System in Health) is a database management system for bibliographic information, developed by BIREME/PAHO.

## Quick Start

### Installation
```bash
# Build from source
./generateApp64.sh

# Or download pre-built binaries from releases
# Extract and add to PATH
```

### Basic Usage
```bash
# Show help
./mx

# Display database records
./mx database from=1 count=10

# Export to ISO format
./mx database iso=output.iso now

# Import from ISO
./mx iso=input.iso create=newdb now
```

## Core Utilities

### mx - Main Database Utility
The primary tool for database operations.

**Basic Syntax:**
```bash
mx [database] [parameters] [format] [output]
```

**Common Operations:**

**View Records:**
```bash
# Show first 10 records
mx mydb from=1 count=10

# Show specific record
mx mydb mfn=123

# Show with custom format
mx mydb "pft=mfn,': ',v245^a,#" from=1 count=5
```

**Database Operations:**
```bash
# Create new database
mx seq=input.txt create=newdb now

# Copy database
mx sourcedb copy=targetdb now

# Append records
mx sourcedb append=targetdb now

# Update records
mx sourcedb proc=@update.prc copy=sourcedb now
```

**Export/Import:**
```bash
# Export to ISO 2709
mx mydb iso=export.iso now

# Import from ISO
mx iso=import.iso create=mydb now

# Export to text
mx mydb "pft=@format.pft" lw=0 now > output.txt
```

**Search and Filter:**
```bash
# Boolean search
mx mydb "bool=cancer and therapy" "pft=v245^a,#"

# Field-specific search  
mx mydb "bool=cancer$" "pft=mfn,v245^a,#"

# Date range
mx mydb from=100 to=200 "pft=mfn,v245^a,#"
```

## Database Structure

### Field Definition Table (.fdt)
Defines the database schema:
```
Field Name                    Tag Len Rep Subfields
Title                         245 1000 0  abchnp
Author                        100 1000 0  abcdequ
Subject                       650 1000 1  aevxyz2
```

### Field Selection Table (.fst)  
Defines indexing for searches:
```
1 0 v100^a          # Author index
2 0 v245^a          # Title index  
3 0 (v650^a/)       # Subject index (repeatable)
```

## Format Language (PFT)

CISIS uses a powerful formatting language for output:

**Basic Elements:**
```
v245^a              # Field 245 subfield a
v100^a,', ',v100^b  # Concatenate with literal text
mfn                 # Master file number
#                   # New line
```

**Conditional Formatting:**
```
if p(v100) then v100^a fi                    # If field exists
if v100^a:'Smith' then 'Author found' fi     # If contains text
if a(v100) then 'No author' fi               # If field absent
```

**Repeatable Fields:**
```
(v650^a/)           # All occurrences, one per line
(v650^a,'; '/)      # All occurrences, semicolon separated
(|Subject: |v650^a/)# With prefix for each occurrence
```

**Advanced Formatting:**
```bash
# Custom format file (format.pft)
'Title: 'v245^a/
'Author: 'v100^a/
if p(v650) then 'Subjects: '(v650^a,'; '/) fi/

# Use format file
mx mydb "pft=@format.pft" now
```

## Common Use Cases

### Library Catalog Management
```bash
# Import MARC records
mx iso=catalog.iso create=library now

# Search by author
mx library "bool=shakespeare$" "pft='Title: 'v245^a/'Author: 'v100^a/#"

# Generate catalog cards
mx library "pft=@catalog-card.pft" lw=80 now > cards.txt
```

### Bibliographic Database Migration
```bash
# Export for migration
mx olddb "pft=@marc21.pft" lw=0 now > export.mrc

# Convert between formats
mx iso=input.iso "proc='d*','a245  'v1" create=converted now
```

### Statistical Reports
```bash
# Count records by year
mx mydb "pft=if p(v260^c) then v260^c fi,x1" lw=0 now | sort | uniq -c

# Generate frequency table
mx mydb "pft=(v650^a/)" lw=0 now | sort | uniq -c | sort -nr
```

## Processing Language (PROC)

Modify records during operations:

**Basic Commands:**
```
'd*'                # Delete all fields
'd245'              # Delete field 245
'a245  New title'   # Add field 245
'h100'              # Hold field 100 (copy to end)
```

**Examples:**
```bash
# Add new field to all records
mx mydb proc="'a999  Processed on 2024'" copy=mydb now

# Update existing field
mx mydb proc="if p(v245) then 'd245','a245  'v245^a,' [Updated]' fi" copy=mydb now

# Conditional processing
mx mydb proc="if v100^a:'Smith' then 'a700  'v100 fi" copy=mydb now
```

## File Types

- **`.mst`** - Master file (records)
- **`.xrf`** - Cross-reference file (record pointers)
- **`.fdt`** - Field definition table
- **`.fst`** - Field selection table (indexing)
- **`.ifp`** - Inverted file (index)
- **`.iso`** - ISO 2709 export format
- **`.pft`** - Print format table
- **`.prc`** - Processing commands

## Tips and Best Practices

1. **Always backup** databases before major operations
2. **Use transactions** with `now` parameter for immediate execution
3. **Test formats** on small datasets first
4. **Index frequently searched fields** in FST
5. **Use meaningful field tags** following standards (MARC, etc.)
6. **Validate data** before import operations

## Error Handling

Common errors and solutions:

```bash
# Database locked
mx mydb unlock now

# Corrupted index
mx mydb fullinv=mydb now

# Memory issues with large operations
mx mydb from=1 to=1000 copy=temp now
mx mydb from=1001 to=2000 append=temp now
```

## Advanced Features

### Gizmo Tables
Data conversion tables for field transformations.

### Boolean Search
Complex search expressions with AND, OR, NOT operators.

### Batch Processing
Process multiple databases or large datasets efficiently.

## Documentation Links

- [CISIS Manual](http://wiki.bireme.org/en/index.php/CISIS)
- [Format Language Reference](http://wiki.bireme.org/en/index.php/CISIS_Formatting_Language)
- [Processing Language](http://wiki.bireme.org/en/index.php/CISIS_Processing_Language)

## Examples Repository

See the `examples/` directory for:
- Sample databases
- Format templates
- Migration scripts
- Common use cases
