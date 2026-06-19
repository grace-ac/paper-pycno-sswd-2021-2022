# Network Diagram Generator for S11 Data

This directory contains a Python script that generates network diagrams showing the relationships between GO Biological Process terms and UniProt IDs from the supplemental data file `S11-DEGlist_enrichedprocesses_2021-2022.tab`.

## Generated Files

The script generates two network visualizations:

1. **network-diagram-S11-GO-UniProt.png** - Spring layout showing all nodes and their connections
2. **network-diagram-S11-GO-UniProt-bipartite.png** - Bipartite layout with GO terms on the left and UniProt IDs on the right

## Script Description

**File:** `generate_network_diagram.py`

This script:
- Reads the first two columns from the supplemental file
- Creates a bipartite network graph showing relationships between GO terms and UniProt IDs
- Generates statistical analysis of the network
- Creates two visualization layouts (spring and bipartite)
- Saves high-resolution PNG images to the `analyses` directory

## Requirements

Python 3 with the following packages:
- pandas
- networkx
- matplotlib
- numpy

## Installation

Install required packages:
```bash
pip3 install networkx matplotlib pandas numpy
```

## Usage

Run the script from the `code` directory:
```bash
cd code
python3 generate_network_diagram.py
```

Or make it executable and run directly:
```bash
chmod +x generate_network_diagram.py
./generate_network_diagram.py
```

## Output

The script generates:
- Network statistics printed to console
- Two PNG files saved to `../analyses/`:
  - `network-diagram-S11-GO-UniProt.png` (spring layout)
  - `network-diagram-S11-GO-UniProt-bipartite.png` (bipartite layout)

## Network Statistics

The script analyzes:
- Total number of nodes and edges
- Network density
- GO terms and their associated UniProt ID counts
- UniProt IDs with multiple GO term associations
- GO term overlap analysis (which terms share the most proteins)

## Visualization Details

### Spring Layout (network-diagram-S11-GO-UniProt.png)
- **Blue nodes**: GO Biological Process terms
- **Coral/Red nodes**: UniProt IDs
- **Node size**: Proportional to number of connections
- **Edges**: Gray lines showing associations
- Labels shown only for GO terms for clarity

### Bipartite Layout (network-diagram-S11-GO-UniProt-bipartite.png)
- **Left side**: GO Biological Process terms (blue nodes)
- **Right side**: UniProt IDs (coral/red nodes)
- **Annotations**: Number of connections shown for each GO term
- Clear two-column layout showing the bipartite nature of the network

## Key Findings

From the analysis of the data:
- **9 unique GO Biological Process terms**
- **408 unique UniProt IDs**
- **488 total connections**
- Top GO terms by number of associated IDs:
  1. proteolysis (152 IDs)
  2. proteasome-mediated ubiquitin-dependent protein catabolic process (84 IDs)
  3. ubiquitin-dependent protein catabolic process (72 IDs)
  4. translation (64 IDs)

- **69 UniProt IDs** are associated with multiple GO terms, showing functional overlap
- Highest overlap is between "proteasome-mediated ubiquitin-dependent protein catabolic process" and "ubiquitin-dependent protein catabolic process" with 24 shared IDs

## Author

Generated for the paper-pycno-sswd-2021-2022 project  
Date: November 19, 2025
