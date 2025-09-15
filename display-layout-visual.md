# Display Configuration Layout

## Physical Arrangement

```
    Samsung 55" TV/Monitor               Dell 32" Curved (Top)
┌──────────────────────────┐         ┌──────────────────────────┐
│                          │         │                          │
│                          │         │          DP-4            │
│         DP-6             │         │     (3840x2160)          │
│    (3840x2160)           │         │                          │
│                          │         └──────────────────────────┘
│   Position: 0,1121       │         Position: 3840,0
│                          │         
│                          │              Dell 32" Curved (Bottom)
│                          │         ┌──────────────────────────┐
│                          │         │                          │
│                          │         │          DP-2            │
└──────────────────────────┘         │     (3840x2160)          │
                                     │                          │
                                     └──────────────────────────┘
                                     Position: 3840,2160
```

## Display Specifications

### Samsung 55" (DP-6)
- **Port**: DP-6
- **Resolution**: 3840x2160 @ 30Hz
- **Physical Size**: 1210mm x 680mm (55" diagonal)
- **Position**: X=0, Y=1121
- **EDID Identifier**: Samsung Electric Company
- **Type**: TV/Monitor Combo

### Dell 32" Curved #1 (DP-4)
- **Port**: DP-4  
- **Resolution**: 3840x2160 @ 60Hz
- **Physical Size**: 697mm x 392mm (32" diagonal)
- **Position**: X=3840, Y=0 (Top Right)
- **EDID Identifier**: Dell Inc. 32"
- **Configuration**: Stacked above Dell #2

### Dell 32" Curved #2 (DP-2)
- **Port**: DP-2
- **Resolution**: 3840x2160 @ 60Hz  
- **Physical Size**: 697mm x 392mm (32" diagonal)
- **Position**: X=3840, Y=2160 (Bottom Right)
- **EDID Identifier**: Dell Inc. 32"
- **Configuration**: Stacked below Dell #1

## Total Canvas Size
- **Width**: 7680 pixels (3840 + 3840)
- **Height**: 4320 pixels (2160 + 2160 vertical stack)
- **Total Pixels**: 33,177,600

## xrandr Command for This Layout
```bash
xrandr --output DP-6 --mode 3840x2160 --pos 0x1121 \
       --output DP-4 --mode 3840x2160 --pos 3840x0 \
       --output DP-2 --mode 3840x2160 --pos 3840x2160
```

## Visual Coordinate Map
```
Origin (0,0) ←──────────────────────────┐
                                        ↓
    X-axis →                      [DP-4 Dell Top]
    0        3840      7680       @ 3840,0
Y   ┌─────────┬─────────┐
↓   │         │ Dell #1 │ 0
a 1121├─────────┼─────────┤
x   │ Samsung │         │ 2160
i   │  DP-6   │ Dell #2 │
s   │         │  DP-2   │ 4320
    └─────────┴─────────┘
```

## Connection Topology
```
HPC Tower 1 (RTX A4000)
├── DP-6 → 5-way HDMI Switch → Samsung 55"
├── DP-4 → 5-way HDMI Switch → Dell 32" (Top)
└── DP-2 → 5-way HDMI Switch → Dell 32" (Bottom)
```

## Notes
- Samsung is offset down by 1121 pixels to roughly center it between the stacked Dells
- Dell monitors are perfectly stacked (one at Y=0, other at Y=2160)
- All displays running at 4K resolution (3840x2160)
- Samsung limited to 30Hz through HDMI switch
- Dells capable of 60Hz on direct DisplayPort connection