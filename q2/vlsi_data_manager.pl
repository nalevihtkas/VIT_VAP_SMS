#!/usr/bin/env perl
use strict;
use warnings;

print "==== VLSI DESIGN DATA MANAGER ====\n";

# ---------------------------------------------------------
# 1. Arrays: Process nodes, indexing, length, slices
# ---------------------------------------------------------
print "\n--- Arrays: Process Nodes ---\n";

my @nodes = ("180nm", "90nm", "65nm", "28nm", "7nm");

print "All process nodes: @nodes\n";

# Access by index
print "First node  : $nodes[0]\n";
print "Last node   : $nodes[$#nodes]\n";

# Length using scalar
my $num_nodes = scalar @nodes;
print "Number of nodes (scalar \@nodes): $num_nodes\n";

# Array slices
my @older_nodes  = @nodes[0, 1];      # 180nm, 90nm
my @advanced_set = @nodes[2..4];      # 65nm, 28nm, 7nm

print "Older nodes slice (indices 0,1): @older_nodes\n";
print "Advanced nodes slice (2..4)    : @advanced_set\n";

# ---------------------------------------------------------
# 2. List of threshold voltages: push, pop, shift, unshift
# ---------------------------------------------------------
print "\n--- List Operations: Threshold Voltages ---\n";

my @vt_list = (0.7, 0.8, 0.9);

print "Initial Vt list: @vt_list\n";

push @vt_list, 1.0;
print "After push(1.0)           : @vt_list\n";

unshift @vt_list, 0.6;
print "After unshift(0.6)        : @vt_list\n";

my $last_vt = pop @vt_list;
print "After pop() (removed $last_vt): @vt_list\n";

my $first_vt = shift @vt_list;
print "After shift() (removed $first_vt): @vt_list\n";

# ---------------------------------------------------------
# 3. List behavior: assigning lists, split, scalar list assignment
# ---------------------------------------------------------
print "\n--- Lists vs Arrays ---\n";

# A list directly
(1, 2, 3, 4);  # just a list, not stored

# Assign list to array
my @nums = (1, 2, 3, 4);
print "Array \@nums from list: @nums\n";

# Assign list to scalars
my ($a, $b) = (10, 20);
print "Scalars from list: a = $a, b = $b\n";

# split into list
my $power_str = "Static Dynamic Leakage";
my @power_components = split ' ', $power_str;
print "Power components (split): @power_components\n";

# ---------------------------------------------------------
# 4. Hash: VLSI chip block details & hash operations
# ---------------------------------------------------------
print "\n--- Hash: Chip Block Details & Operations ---\n";

my %chip_block = (
    name => "CoreBlock",
    tech => "28nm",
    vdd  => 1.0,
    area => 25.6,     # mm^2 (example)
);

print "Initial Chip Block:\n";
print "  Name : $chip_block{name}\n";
print "  Tech : $chip_block{tech}\n";
print "  Vdd  : $chip_block{vdd} V\n";
print "  Area : $chip_block{area} mm^2\n";

# Add new key (frequency)
$chip_block{freq} = "1.2GHz";
print "\nAfter adding frequency:\n";
print "  Freq : $chip_block{freq}\n";

# Update a key (vdd)
$chip_block{vdd} = 0.9;
print "Updated Vdd: $chip_block{vdd} V\n";

# Check key existence
print "Key 'freq' exists\n" if exists $chip_block{freq};

# Print all keys and values
print "\nAll keys and values (join):\n";
print "  Keys   : ", join(", ", keys %chip_block), "\n";
print "  Values : ", join(", ", values %chip_block), "\n";

# Delete a key
delete $chip_block{freq};
print "\nAfter deleting 'freq':\n";
print "  Keys   : ", join(", ", keys %chip_block), "\n";
print "  Values : ", join(", ", values %chip_block), "\n";

# ---------------------------------------------------------
# 5. Multidimensional Hashes: Hash of hashes (logic blocks)
# ---------------------------------------------------------
print "\n--- Multidimensional Hash: Logic Blocks (Hash of Hashes) ---\n";

my %blocks = (
    ALU => {
        power => 12.5,
        delay => 2.1,
        area  => 220,
    },
    REGFILE => {
        power => 8.3,
        delay => 1.5,
        area  => 180,
    },
    MULT => {
        power => 20.0,
        delay => 3.8,
        area  => 350,
    },
);

print "ALU power : $blocks{ALU}->{power} mW\n";
print "MULT area : $blocks{MULT}->{area} µm^2\n";

# Loop over blocks and print
print "\nAll blocks (Hash of Hashes traversal):\n";
foreach my $blk (keys %blocks) {
    my $p = $blocks{$blk}->{power};
    my $d = $blocks{$blk}->{delay};
    my $a = $blocks{$blk}->{area};
    print "  $blk => Power = $p mW, Delay = $d ns, Area = $a µm^2\n";
}

# ---------------------------------------------------------
# 6. Hash of Arrays: lab students by department
# ---------------------------------------------------------
print "\n--- Hash of Arrays: Lab Students ---\n";

my %lab_students = (
    ECE  => ["Arun", "Latha", "Vijay"],
    CSE  => ["Kiran", "Prema"],
    VLSI => ["Sakthi", "Meena", "Ravi"],
);

print "ECE students   : @{$lab_students{ECE}}\n";
print "VLSI students  : @{$lab_students{VLSI}}\n";
print "First CSE stud.: $lab_students{CSE}->[0]\n";

# ---------------------------------------------------------
# 7. Array of Hashes: VLSI testchips
# ---------------------------------------------------------
print "\n--- Array of Hashes: VLSI Testchips ---\n";

my @testchips = (
    { name => "TC1", size => 10.5, node => "65nm" },
    { name => "TC2", size => 7.2,  node => "28nm" },
    { name => "TC3", size => 4.8,  node => "7nm"  },
);

foreach my $chip (@testchips) {
    print "Testchip: $chip->{name}, Size: $chip->{size} mm^2, Node: $chip->{node}\n";
}

# ---------------------------------------------------------
# 8. Hash Traversal: keys, values, each, sorted
# ---------------------------------------------------------
print "\n--- Hash Traversal Methods ---\n";

my %student = (
    name => "Sakthi",
    age  => 25,
    dept => "VLSI",
);

print "Using keys():\n";
foreach my $key (keys %student) {
    my $val = $student{$key};
    print "  $key => $val\n";
}

print "\nUsing values():\n";
foreach my $val (values %student) {
    print "  $val\n";
}

print "\nUsing each():\n";
while (my ($k, $v) = each %student) {
    print "  $k => $v\n";
}

print "\nSorted keys traversal:\n";
foreach my $k (sort keys %student) {
    print "  $k => $student{$k}\n";
}

# ---------------------------------------------------------
# 9. Scalars, undef, numeric & string comparisons
# ---------------------------------------------------------
print "\n--- Scalars & Comparisons ---\n";

my $vt   = 0.4;
my $chip = "ASIC1";
my $pi   = 3.14;
my $undef_val;

print "Scalar vt   : $vt\n";
print "Scalar chip : $chip\n";
print "Scalar pi   : $pi\n";
print "undef_val   : ", (defined $undef_val ? $undef_val : "undef"), "\n";

# Numeric comparisons on imaginary numeric process sizes
my $n1 = 65;
my $n2 = 28;

print "\nNumeric comparison of nodes (as numbers):\n";
print "  n1 = $n1, n2 = $n2\n";
print "  n1 < n2 ? ", ($n1 < $n2 ? "YES" : "NO"), "\n";

# String comparisons on node names
my $s1 = "28nm";
my $s2 = "7nm";

print "\nString comparison of node names:\n";
print "  s1 eq s2 ? ", ($s1 eq $s2 ? "YES" : "NO"), "\n";
print "  s1 lt s2 ? ", ($s1 lt $s2 ? "YES" : "NO"), "  (lexicographic)\n";

# String comparison on chip names
my $chip2 = "ASIC2";
print "  chip eq chip2 ? ", ($chip eq $chip2 ? "YES" : "NO"), "\n";

# ---------------------------------------------------------
# 10. Scalar context: scalar on arrays, function returns, ternary
# ---------------------------------------------------------
print "\n--- Scalar Context Demonstration ---\n";

# scalar on array
print "scalar \@nodes = ", scalar @nodes, " (count of nodes)\n";

# Function that returns a list
sub give_process_list {
    return ("180nm", "90nm", "65nm", "28nm", "7nm");
}

# List context
my @plist = give_process_list();
print "Process list in list context : @plist\n";

# Scalar context
my $plist_scalar = scalar give_process_list();
print "Process list in scalar context: $plist_scalar\n";
# In scalar context for a simple list-returning sub, this is
# number of elements in the returned list.

# Ternary with scalar context
my $node_message = scalar @nodes > 3 ? "Many process nodes defined" : "Few process nodes";
print "Ternary message (scalar context on \@nodes): $node_message\n";

print "\n==== END OF VLSI DESIGN DATA MANAGER ====\n";
