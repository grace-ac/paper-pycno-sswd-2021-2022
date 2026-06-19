#!/usr/bin/env python3
"""
Network Diagram Generator for S11-DEGlist_enrichedprocesses_2021-2022.tab

This script creates a network diagram showing the relationships between 
GO Biological Process terms and UniProt IDs.

The network diagram shows:
- GO terms as one set of nodes (blue)
- UniProt IDs as another set of nodes (coral/red)
- Connections showing which IDs are associated with which GO terms
- This visualizes how certain genes/proteins may be involved in multiple biological processes

Author: Generated for paper-pycno-sswd-2021-2022 project
Date: 2025-11-19
"""

import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from collections import Counter
import os

# Configuration
INPUT_FILE = "../supplemental/S11-DEGlist_enrichedprocesses_2021-2022.tab"
OUTPUT_DIR = "../analyses"
OUTPUT_FILE = "network-diagram-S11-GO-UniProt.png"

def read_data(filepath):
    """Read the supplemental file and extract the first two columns."""
    print(f"Reading data from: {filepath}")
    data = pd.read_csv(filepath, sep='\t', usecols=[0, 1])
    data.columns = ['GO_Term', 'UniProt_ID']
    
    # Create simplified GO term names
    data['GO_Term_Short'] = data['GO_Term'].str.replace(r'GO:\d+~', '', regex=True)
    
    print(f"  Total rows: {len(data)}")
    print(f"  Unique GO terms: {data['GO_Term_Short'].nunique()}")
    print(f"  Unique UniProt IDs: {data['UniProt_ID'].nunique()}")
    
    return data

def create_bipartite_graph(data):
    """Create a bipartite graph from the data."""
    print("\nCreating bipartite graph...")
    
    # Create a bipartite graph
    B = nx.Graph()
    
    # Add nodes with bipartite attribute
    # Set 0 = GO terms, Set 1 = UniProt IDs
    go_terms = data['GO_Term_Short'].unique()
    uniprot_ids = data['UniProt_ID'].unique()
    
    B.add_nodes_from(go_terms, bipartite=0)
    B.add_nodes_from(uniprot_ids, bipartite=1)
    
    # Add edges
    edges = [(row['GO_Term_Short'], row['UniProt_ID']) 
             for _, row in data.iterrows()]
    B.add_edges_from(edges)
    
    print(f"  Nodes: {B.number_of_nodes()}")
    print(f"  Edges: {B.number_of_edges()}")
    print(f"  Density: {nx.density(B):.4f}")
    
    return B, go_terms, uniprot_ids

def analyze_network(B, data, go_terms, uniprot_ids):
    """Analyze and print network statistics."""
    print("\n" + "="*60)
    print("NETWORK STATISTICS")
    print("="*60)
    
    # Count connections per GO term
    go_connections = data['GO_Term_Short'].value_counts()
    print("\nGO Terms and their associated UniProt ID counts:")
    print("-" * 60)
    for term, count in go_connections.items():
        print(f"  {term}: {count} IDs")
    
    # Count connections per UniProt ID
    id_connections = data['UniProt_ID'].value_counts()
    print(f"\nUniProt IDs with multiple GO term associations:")
    print("-" * 60)
    multi_term_ids = id_connections[id_connections > 1]
    print(f"  Total IDs with 2+ terms: {len(multi_term_ids)}")
    print(f"  Top 10 most connected IDs:")
    for id_name, count in id_connections.head(10).items():
        terms = data[data['UniProt_ID'] == id_name]['GO_Term_Short'].tolist()
        print(f"    {id_name}: {count} terms - {', '.join(terms[:3])}...")
    
    # Calculate overlap between GO terms
    print(f"\nGO Term Overlap Analysis:")
    print("-" * 60)
    
    # Find which GO terms share the most proteins
    from itertools import combinations
    go_list = list(go_terms)
    max_overlap = 0
    max_pair = None
    
    for term1, term2 in combinations(go_list, 2):
        ids1 = set(data[data['GO_Term_Short'] == term1]['UniProt_ID'])
        ids2 = set(data[data['GO_Term_Short'] == term2]['UniProt_ID'])
        overlap = len(ids1.intersection(ids2))
        if overlap > max_overlap:
            max_overlap = overlap
            max_pair = (term1, term2)
    
    if max_pair:
        print(f"  Highest overlap ({max_overlap} shared IDs):")
        print(f"    - {max_pair[0]}")
        print(f"    - {max_pair[1]}")
    
    print("="*60 + "\n")

def plot_network_spring(B, go_terms, uniprot_ids, output_path):
    """Create a spring layout network visualization."""
    print(f"\nCreating spring layout network diagram...")
    
    # Create figure
    plt.figure(figsize=(16, 14))
    
    # Use spring layout
    pos = nx.spring_layout(B, k=0.5, iterations=50, seed=42)
    
    # Separate nodes by type
    go_nodes = [n for n in B.nodes() if n in go_terms]
    id_nodes = [n for n in B.nodes() if n in uniprot_ids]
    
    # Calculate node sizes based on degree
    go_degrees = [B.degree(n) for n in go_nodes]
    max_go_degree = max(go_degrees) if go_degrees else 1
    go_sizes = [300 + (B.degree(n) / max_go_degree) * 1000 for n in go_nodes]
    
    id_degrees = [B.degree(n) for n in id_nodes]
    max_id_degree = max(id_degrees) if id_degrees else 1
    id_sizes = [50 + (B.degree(n) / max_id_degree) * 200 for n in id_nodes]
    
    # Draw edges with transparency
    nx.draw_networkx_edges(B, pos, alpha=0.15, edge_color='gray', width=0.5)
    
    # Draw GO term nodes
    nx.draw_networkx_nodes(B, pos, nodelist=go_nodes, 
                          node_color='steelblue', 
                          node_size=go_sizes,
                          node_shape='o',
                          alpha=0.9,
                          linewidths=2,
                          edgecolors='navy')
    
    # Draw UniProt ID nodes
    nx.draw_networkx_nodes(B, pos, nodelist=id_nodes, 
                          node_color='coral', 
                          node_size=id_sizes,
                          node_shape='o',
                          alpha=0.6,
                          linewidths=0.5,
                          edgecolors='darkred')
    
    # Draw labels only for GO terms
    go_labels = {n: n for n in go_nodes}
    nx.draw_networkx_labels(B, pos, labels=go_labels, 
                           font_size=9, 
                           font_weight='bold',
                           font_color='black')
    
    # Create legend
    go_patch = mpatches.Patch(color='steelblue', label='GO Biological Process Terms')
    id_patch = mpatches.Patch(color='coral', label='UniProt IDs')
    plt.legend(handles=[go_patch, id_patch], 
              loc='upper left', 
              fontsize=11,
              frameon=True,
              fancybox=True,
              shadow=True)
    
    plt.title('Network Diagram: GO Biological Processes and Associated UniProt IDs\n' +
              'Node size indicates number of connections',
              fontsize=16, fontweight='bold', pad=20)
    plt.axis('off')
    plt.tight_layout()
    
    # Save figure
    plt.savefig(output_path, dpi=300, bbox_inches='tight', facecolor='white')
    print(f"  Saved: {output_path}")
    plt.close()

def plot_network_bipartite(B, go_terms, uniprot_ids, output_path):
    """Create a bipartite layout network visualization."""
    print(f"\nCreating bipartite layout network diagram...")
    
    # Create figure
    fig, ax = plt.subplots(figsize=(18, 14))
    
    # Create bipartite layout
    go_nodes = list(go_terms)
    id_nodes = list(uniprot_ids)
    
    # Position GO terms on the left, UniProt IDs on the right
    pos = {}
    
    # GO terms on the left (x=0)
    go_spacing = 1.0 / (len(go_nodes) + 1)
    for i, node in enumerate(go_nodes):
        pos[node] = (0, 1 - (i + 1) * go_spacing)
    
    # UniProt IDs on the right (x=1)
    id_spacing = 1.0 / (len(id_nodes) + 1)
    for i, node in enumerate(id_nodes):
        pos[node] = (1, 1 - (i + 1) * id_spacing)
    
    # Draw edges
    nx.draw_networkx_edges(B, pos, alpha=0.08, edge_color='gray', width=0.3, ax=ax)
    
    # Calculate node sizes
    go_degrees = [B.degree(n) for n in go_nodes]
    max_go_degree = max(go_degrees) if go_degrees else 1
    go_sizes = [500 + (B.degree(n) / max_go_degree) * 1500 for n in go_nodes]
    
    id_degrees = [B.degree(n) for n in id_nodes]
    id_sizes = [30 if B.degree(n) == 1 else 60 for n in id_nodes]
    
    # Draw GO term nodes
    nx.draw_networkx_nodes(B, pos, nodelist=go_nodes, 
                          node_color='steelblue', 
                          node_size=go_sizes,
                          node_shape='o',
                          alpha=0.9,
                          linewidths=2,
                          edgecolors='navy',
                          ax=ax)
    
    # Draw UniProt ID nodes (smaller)
    nx.draw_networkx_nodes(B, pos, nodelist=id_nodes, 
                          node_color='coral', 
                          node_size=id_sizes,
                          node_shape='o',
                          alpha=0.5,
                          linewidths=0.5,
                          edgecolors='darkred',
                          ax=ax)
    
    # Draw GO term labels
    go_labels = {n: n for n in go_nodes}
    label_pos = {n: (pos[n][0] - 0.15, pos[n][1]) for n in go_nodes}
    nx.draw_networkx_labels(B, label_pos, labels=go_labels, 
                           font_size=10, 
                           font_weight='bold',
                           font_color='black',
                           horizontalalignment='right',
                           ax=ax)
    
    # Add count annotations
    for node in go_nodes:
        x, y = pos[node]
        degree = B.degree(node)
        ax.annotate(f'n={degree}', 
                   xy=(x + 0.05, y), 
                   fontsize=8, 
                   color='navy',
                   weight='bold')
    
    # Create legend
    go_patch = mpatches.Patch(color='steelblue', label='GO Biological Process Terms')
    id_patch = mpatches.Patch(color='coral', label='UniProt IDs')
    plt.legend(handles=[go_patch, id_patch], 
              loc='upper center', 
              fontsize=12,
              frameon=True,
              fancybox=True,
              shadow=True,
              ncol=2)
    
    plt.title('Bipartite Network: GO Terms ↔ UniProt IDs\n' +
              'Lines connect UniProt IDs to their associated GO terms',
              fontsize=16, fontweight='bold', pad=20)
    plt.axis('off')
    plt.tight_layout()
    
    # Save figure
    plt.savefig(output_path, dpi=300, bbox_inches='tight', facecolor='white')
    print(f"  Saved: {output_path}")
    plt.close()

def main():
    """Main function to generate network diagrams."""
    print("="*60)
    print("Network Diagram Generator for S11 Data")
    print("="*60)
    
    # Change to code directory
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    # Read data
    data = read_data(INPUT_FILE)
    
    # Create bipartite graph
    B, go_terms, uniprot_ids = create_bipartite_graph(data)
    
    # Analyze network
    analyze_network(B, data, go_terms, uniprot_ids)
    
    # Create output directory if it doesn't exist
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    # Generate visualizations
    output_spring = os.path.join(OUTPUT_DIR, OUTPUT_FILE)
    plot_network_spring(B, go_terms, uniprot_ids, output_spring)
    
    output_bipartite = os.path.join(OUTPUT_DIR, "network-diagram-S11-GO-UniProt-bipartite.png")
    plot_network_bipartite(B, go_terms, uniprot_ids, output_bipartite)
    
    print("\n" + "="*60)
    print("Network diagram generation complete!")
    print("="*60)

if __name__ == "__main__":
    main()
