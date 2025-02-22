### **Advanced Gradient Module - Usage Instructions**

This document provides step-by-step instructions on how to use the **Advanced Gradient Module** in **Roblox Luau**. It covers every function, how to call them, and what parameters they require.

---

## **1. Requiring the Module**

First, make sure the module script is placed in **ReplicatedStorage** or any accessible location in your game.

```lua
local AdvancedGradientModule = require(game.ReplicatedStorage.AdvancedGradientModule)
```

---

## **2. Converting HEX to Color3 (`hexToColor3`)**

### **Function Definition:**
```lua
local function hexToColor3(hexCode) -> Color3
```

### **Usage:**
```lua
local color = AdvancedGradientModule.hexToColor3("#FFAA33")
print(color) -- Output: Color3.new(1, 0.666, 0.2)
```

### **Parameters:**
- `hexCode` (**string**) - A valid 6-character HEX color string.

### **Returns:**
- A `Color3` object representing the converted color.

---

## **3. Interpolation Function (`applyInterpolation`)**

### **Function Definition:**
```lua
local function applyInterpolation(t: number, mode: string) -> number
```

### **Usage:**
```lua
local easedValue = AdvancedGradientModule.applyInterpolation(0.5, "EaseOutQuad")
print(easedValue) -- Output: 0.75
```

### **Parameters:**
- `t` (**number**) - The interpolation factor (0 to 1).
- `mode` (**string**) - The easing mode (`"Linear"`, `"EaseInQuad"`, `"EaseOutQuad"`, `"EaseInOutQuad"`).

### **Returns:**
- A number representing the adjusted interpolation value.

---

## **4. Calculating Automatic Steps (`calculateAutoSteps`)**

### **Function Definition:**
```lua
local function calculateAutoSteps(c1: Color3, c2: Color3) -> number
```

### **Usage:**
```lua
local steps = AdvancedGradientModule.calculateAutoSteps(Color3.new(1, 0, 0), Color3.new(0, 0, 1))
print(steps) -- Output: Steps between red and blue
```

### **Parameters:**
- `c1` (**Color3**) - The first color.
- `c2` (**Color3**) - The second color.

### **Returns:**
- A number representing the calculated steps (clamped between 2 and 20).

---

## **5. Creating a UI Gradient (`createAdvancedGradient`)**

### **Function Definition:**
```lua
function AdvancedGradientModule.createAdvancedGradient(parentUiObject: GuiObject, hexColor1: string, hexColor2: string, stepMode: string, stepCount: number?, interpolationMode: string) -> UIGradient
```

### **Usage:**
```lua
local frame = script.Parent
local gradient = AdvancedGradientModule.createAdvancedGradient(frame, "#FF0000", "#0000FF", "Auto", nil, "EaseInOutQuad")
```

### **Parameters:**
- `parentUiObject` (**GuiObject**) - The UI element where the gradient will be applied.
- `hexColor1` (**string**) - The starting HEX color.
- `hexColor2` (**string**) - The ending HEX color.
- `stepMode` (**string**) - Either `"Auto"` (auto steps) or `"Manual"` (use `stepCount`).
- `stepCount` (**number**, optional) - The number of gradient steps (if manual mode is chosen).
- `interpolationMode` (**string**) - The easing method.

### **Returns:**
- A `UIGradient` instance applied to the parent UI object.

---

## **6. Applying Stepped Color Changes (`colorPropsStepped`)**

### **Function Definition:**
```lua
function AdvancedGradientModule.colorPropsStepped(porpList: {GuiObject}, hexColor1: string, hexColor2: string, generationMethod: string, midColorHex: string?)
```

### **Usage:**
```lua
local frames = {frame1, frame2, frame3, frame4}
AdvancedGradientModule.colorPropsStepped(frames, "#FF0000", "#0000FF", "MultiColor", "#00FF00")
```

### **Parameters:**
- `porpList` (**table of GuiObjects**) - A list of UI objects where colors will be applied.
- `hexColor1` (**string**) - The first color.
- `hexColor2` (**string**) - The second color.
- `generationMethod` (**string**) - The method (`"Linear"`, `"EaseInQuad"`, `"MultiColor"`).
- `midColorHex` (**string**, optional) - A third color to be used in `"MultiColor"` mode.

### **Returns:**
- Modifies UI elements directly, no return value.

---

## **7. Example Use Case: Applying a Gradient to Multiple UI Elements**

### **Step-by-Step Code Implementation:**
```lua
-- Load the module
local AdvancedGradientModule = require(game.ReplicatedStorage.AdvancedGradientModule)

-- Define UI Elements
local uiFrame = script.Parent.Frame
local uiButtons = {script.Parent.Button1, script.Parent.Button2, script.Parent.Button3}

-- Apply a smooth UI gradient
AdvancedGradientModule.createAdvancedGradient(uiFrame, "#FF0000", "#0000FF", "Auto", nil, "EaseOutQuad")

-- Apply stepped color transitions to multiple buttons
AdvancedGradientModule.colorPropsStepped(uiButtons, "#FF0000", "#0000FF", "MultiColor", "#00FF00")
```

This will apply a **red-to-blue gradient** on a frame and a **multi-colored transition** on buttons.

---

## **📌 Notes & Best Practices**
- Use **`Auto`** mode for automatic step calculation.
- Use **`MultiColor`** mode when you want a three-color transition.
- UIGradient works best with **frames, buttons, and text elements** in Roblox.
- Make sure all elements exist before calling functions to prevent errors.

---

## **🎯 Final Thoughts**
This module allows for **dynamic and smooth color transitions** in UI elements. By adjusting interpolation methods and step counts, you can create visually appealing UI designs in Roblox games.

Let me know if you need further clarifications or enhancements! 🚀


### **Explanation of the Code & Its Mathematics**
This **Advanced Gradient Module** is written in **Luau 5.1 Lua** and is responsible for generating smooth color gradients in UI elements. It includes:

1. **HEX to Color3 conversion**
2. **Easing/interpolation for smooth transitions**
3. **Automatic calculation of gradient steps**
4. **Gradient generation for UI elements**
5. **Stepped color transitions with optional middle color**

---

## **1. HEX to Color3 Conversion (`hexToColor3`)**
**Mathematical concept**: **Hexadecimal to RGB Conversion**

- A hex color code (e.g., `#FFAA33`) consists of **red (FF), green (AA), and blue (33)** in base-16 (hex).
- The function extracts and converts them to decimal values using:

  ```math
  R = \text{hex} \to \text{decimal}, \quad G = \text{hex} \to \text{decimal}, \quad B = \text{hex} \to \text{decimal}
  ```
- If the conversion fails, it defaults to **white (`255,255,255`)**.

**Example:**

```lua
hexToColor3("#FFAA33") → Color3.new(1, 0.666, 0.2)
```

---

## **2. Easing/Interpolation (`applyInterpolation`)**
**Mathematical concept**: **Easing Functions**

Easing functions modify the rate of change of a value over time.

| Mode | Formula |
|------|---------|
| **Linear** | \( f(t) = t \) |
| **EaseInQuad** | \( f(t) = t^2 \) (slower start) |
| **EaseOutQuad** | \( f(t) = 1 - (1 - t)^2 \) (slower end) |
| **EaseInOutQuad** | \( f(t) = 2t^2 \) if \( t < 0.5 \), else \( 1 - 2(1 - t)^2 \) |

---

### **3. Automatic Gradient Steps (`calculateAutoSteps`)**
**Mathematical concept**: **Color Difference Measurement**

The number of steps for the gradient is determined based on the **largest color difference** (R, G, or B).

```math
\Delta R = |R_1 - R_2|, \quad \Delta G = |G_1 - G_2|, \quad \Delta B = |B_1 - B_2|
```

The maximum difference among them is used to calculate **steps**:

```math
\text{steps} = \left\lfloor \frac{\max(\Delta R, \Delta G, \Delta B)}{5} + 2 \right\rfloor
```

It is clamped between **2 and 20** to prevent too few or too many steps.

---

### **4. Creating the UI Gradient (`createAdvancedGradient`)**
This function:
- Converts **hex colors** to **Color3**
- Calculates **steps** (either auto or manual)
- Uses interpolation to **generate smooth colors** at each step
- Creates and applies a **UIGradient** to the UI element

The color transition formula:

```math
C(t) = C_1 + (C_2 - C_1) \cdot \text{adjustedT}
```

where \( \text{adjustedT} \) is based on the easing function.

---

### **5. Stepped Color Transitions (`colorPropsStepped`)**
This function applies a **color gradient** to multiple UI elements.

#### **Linear Transition**
For a set of UI objects `{porp1, porp2, ..., porpN}`, the color of each step is calculated using:

```math
C_i = C_1 + (C_2 - C_1) \cdot \frac{i}{N-1}
```

where \( i \) is the step index.

#### **Multi-Color Transition**
- If a **midColor** is provided, it first transitions from:
  1. **Start → Midpoint** (First half of the elements)
  2. **Midpoint → End** (Second half of the elements)
- Each phase follows the same formula but applied in two segments.

---

## **📊 Visual Representations**
I generated visualizations showing:

1. **Easing function curves** (Linear, EaseInQuad, EaseOutQuad, EaseInOutQuad)
   
   ![s18005502222025](https://a.okmd.dev/md/67ba02c7ce3ba.png)

2. **Gradient color transitions for different interpolation methods**
   
   ![s18012502222025](https://a.okmd.dev/md/67ba02e5809c9.png)
---

These visualizations demonstrate how different easing functions affect gradient transitions. Let me know if you need further insights! 🚀
Luau : https://luau.org/
Repository : https://github.com/luau-lang/luau
