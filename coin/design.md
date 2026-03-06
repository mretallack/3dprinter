# Trolley Coin Design Specification

## Project Overview

A 3D-printable trolley coin token designed to replace a UK £1 coin for shopping trolleys, with an integrated holder featuring a keyring attachment.

## Target Coin Specifications

### UK £1 Coin (12-sided, introduced 2017)

**Dimensions:**
- Diameter: 23.43mm (maximum, point to point)
- Thickness: 2.8mm
- Weight: 8.75g
- Shape: 12-sided (dodecagonal)
- Composition: Bi-metallic (outer nickel-brass, inner nickel-plated alloy)

**Source:** Royal Mint official specifications

## Design Requirements

### 1. Trolley Token

The token must replicate the dimensions of a UK £1 coin to function in standard UK shopping trolley locks.

**Token Specifications:**
- Diameter: 23.43mm (or slightly larger for tolerance)
- Thickness: 2.8mm minimum (can be slightly thicker for durability)
- Shape: Can be circular or 12-sided to match coin
- Material: PLA or PLA Pro recommended

### 2. Holder Design

The holder must securely contain the token while allowing easy removal when needed.

**Holder Requirements:**
- Must accommodate token dimensions (23.43mm diameter × 2.8mm thickness)
- Secure retention mechanism (friction fit, snap closure, or hinged design)
- Compact form factor suitable for keychain use
- Durable enough for daily use

### 3. Keyring Attachment

**Keyring Hole Specifications:**
- Hole diameter: 4-5mm minimum
- Recommended: 5mm for standard split rings
- Position: Integrated into holder design
- Reinforcement: Adequate material thickness around hole (minimum 2-3mm wall)

**Standard Split Ring Sizes:**
- Small: 22mm outer diameter
- Medium: 25mm outer diameter  
- Large: 28mm outer diameter
- Wire thickness: typically 1-2mm

## Printer Specifications

### Weedo Tina2

**Build Volume:**
- X: 100mm
- Y: 120mm
- Z: 100mm

**Printer Characteristics:**
- Type: FDM (Fused Deposition Modeling)
- Nozzle: 0.4mm standard
- Filament: 1.75mm (PLA/PLA Pro/TPU)
- Resolution: 0.1mm (XYZ)
- Features: Fully assembled, auto-leveling, enclosed design
- Bed: Removable flexible build plate

**Design Constraints:**
- Maximum part size: 100 × 120 × 100mm
- All components must fit within build volume
- Compact printer suitable for small parts like coins and keychains

## Material Recommendations

### Primary Material: PLA
- Easy to print on Tina2
- Sufficient strength for keychain use
- Good dimensional accuracy
- Recommended layer height: 0.2mm
- Infill: 100% for token, 50-100% for holder

### Alternative: PLA Pro
- Enhanced durability
- Better layer adhesion
- Slightly more impact resistant

### Not Recommended: TPU
- Too flexible for coin token application
- May not maintain dimensional accuracy

## Print Settings

**Recommended Settings:**
- Layer height: 0.2mm
- Nozzle temperature: 200-210°C (PLA)
- Bed temperature: 60°C
- Print speed: 40-60mm/s
- Perimeters: ≥3 for strength
- Infill: 100% for token, 50-100% for holder
- Supports: Minimize or avoid if possible

## Design Considerations

### Token Design
1. Exact coin dimensions for trolley compatibility
2. Smooth edges for easy insertion/removal
3. Optional texture or grip pattern on faces
4. Consider slight taper for easier trolley slot insertion

### Holder Design
1. Easy one-handed operation
2. Secure retention to prevent accidental loss
3. Minimal bulk for pocket/keychain carry
4. Smooth exterior to avoid snagging
5. Clear visual indication of token presence

### Keyring Integration
1. Reinforced hole area to prevent tearing
2. Smooth hole edges to prevent split ring damage
3. Positioned for balanced hanging
4. Consider elongated hole (4mm × 6mm) for easier ring attachment

## Testing Criteria

1. **Dimensional accuracy:** Token fits UK shopping trolleys
2. **Retention:** Token stays secure in holder during normal use
3. **Accessibility:** Token can be removed easily when needed
4. **Durability:** Holder withstands repeated use without cracking
5. **Keyring strength:** Attachment point supports weight without failure

## References

- Royal Mint UK £1 Coin Specifications: https://production.royalmint.com/new-pound-coin/
- Weedo Tina2 Specifications: 100×120×100mm build volume
- Standard keyring hole: 4-5mm diameter
- Similar designs on Printables.com use 4mm × 4mm holes successfully
