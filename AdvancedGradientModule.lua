-- Made by c6rae
local AdvancedGradientModule = {}
print(string.format("[%s] Request received; Successfully required.", script.Name))

-----------------------------------------------------------------------
-- 1. HEX to Color3 converter
-----------------------------------------------------------------------
local function hexToColor3(hexCode)
	hexCode = hexCode:gsub("#", "")
	local r = tonumber(hexCode:sub(1, 2), 16)
	local g = tonumber(hexCode:sub(3, 4), 16)
	local b = tonumber(hexCode:sub(5, 6), 16)
	if not (r and g and b) then
		r, g, b = 255, 255, 255
	end
	return Color3.fromRGB(r, g, b)
end

-----------------------------------------------------------------------
-- 2. Easing / Interpolation function
-----------------------------------------------------------------------
local function applyInterpolation(t, mode)
	if mode == "Linear" then
		return t
	elseif mode == "EaseInQuad" then
		return t * t
	elseif mode == "EaseOutQuad" then
		return 1 - (1 - t) * (1 - t)
	elseif mode == "EaseInOutQuad" then
		if t < 0.5 then
			return 2 * t * t
		else
			return 1 - 2 * (1 - t) * (1 - t)
		end
	else
		return t
	end
end

-----------------------------------------------------------------------
-- 3. Automatic steps calculation for gradient (clamped to 20)
-----------------------------------------------------------------------
local function calculateAutoSteps(c1, c2)
	local r1, g1, b1 = c1.R * 255, c1.G * 255, c1.B * 255
	local r2, g2, b2 = c2.R * 255, c2.G * 255, c2.B * 255
	local dR = math.abs(r1 - r2)
	local dG = math.abs(g1 - g2)
	local dB = math.abs(b1 - b2)
	local maxDiff = math.max(dR, dG, dB)
	local steps = math.floor(maxDiff / 5 + 2)
	steps = math.clamp(steps, 2, 20)
	return steps
end

-----------------------------------------------------------------------
-- 4. createAdvancedGradient - for background UIGradients
-----------------------------------------------------------------------
function AdvancedGradientModule.createAdvancedGradient(parentUiObject, hexColor1, hexColor2, stepMode, stepCount, interpolationMode)
	local c1 = hexToColor3(hexColor1)
	local c2 = hexToColor3(hexColor2)

	local steps
	if stepMode == "Auto" then
		steps = calculateAutoSteps(c1, c2)
	else
		steps = stepCount or 10
		steps = math.clamp(steps, 2, 20)
	end

	local uiGradient = parentUiObject:FindFirstChildWhichIsA("UIGradient")
	if not uiGradient then
		uiGradient = Instance.new("UIGradient")
		uiGradient.Name = "AdvancedGradient"
		uiGradient.Parent = parentUiObject
	end

	local keypoints = {}
	for i = 0, steps - 1 do
		local t = i / (steps - 1)
		local adjustedT = applyInterpolation(t, interpolationMode)
		local r = c1.R + (c2.R - c1.R) * adjustedT
		local g = c1.G + (c2.G - c1.G) * adjustedT
		local b = c1.B + (c2.B - c1.B) * adjustedT
		table.insert(keypoints, ColorSequenceKeypoint.new(t, Color3.new(r, g, b)))
	end

	uiGradient.Color = ColorSequence.new(keypoints)
	uiGradient.Rotation = 0
	return uiGradient
end

-----------------------------------------------------------------------
-- 5. colorPropsStepped 
-- Now accepts an optional 5th argument "midColorHex"
-----------------------------------------------------------------------
function AdvancedGradientModule.colorPropsStepped(porpList, hexColor1, hexColor2, generationMethod, midColorHex)
	generationMethod = generationMethod or "Linear"

	local c1 = hexToColor3(hexColor1)
	local c2 = hexToColor3(hexColor2)
	local totalProps = #porpList
	if totalProps < 2 then
		return
	end

	-- if user didn't pass midColorHex, default to #FF00FF
	if not midColorHex then
		midColorHex = "#FF00FF"
	end
	local midColor = hexToColor3(midColorHex)

	if generationMethod == "Linear" then
		-- Old linear approach
		for i, porp in ipairs(porpList) do
			local t = (i - 1) / (totalProps - 1)
			local adjustedT = applyInterpolation(t, "Linear")
			local r = c1.R + (c2.R - c1.R) * adjustedT
			local g = c1.G + (c2.G - c1.G) * adjustedT
			local b = c1.B + (c2.B - c1.B) * adjustedT
			porp.BackgroundColor3 = Color3.new(r, g, b)

			local label = porp:FindFirstChild("ColorCode_TextLabel")
			if label and label:IsA("TextLabel") then
				local rr = math.floor(r * 255)
				local gg = math.floor(g * 255)
				local bb = math.floor(b * 255)
				label.Text = string.format("#%02X%02X%02X", rr, gg, bb)
			end
		end

	elseif generationMethod == "EaseInQuad" then
		-- Nonlinear approach
		for i, porp in ipairs(porpList) do
			local t = (i - 1) / (totalProps - 1)
			local adjustedT = applyInterpolation(t, "EaseInQuad")
			local r = c1.R + (c2.R - c1.R) * adjustedT
			local g = c1.G + (c2.G - c1.G) * adjustedT
			local b = c1.B + (c2.B - c1.B) * adjustedT
			porp.BackgroundColor3 = Color3.new(r, g, b)

			local label = porp:FindFirstChild("ColorCode_TextLabel")
			if label and label:IsA("TextLabel") then
				local rr = math.floor(r * 255)
				local gg = math.floor(g * 255)
				local bb = math.floor(b * 255)
				label.Text = string.format("#%02X%02X%02X", rr, gg, bb)
			end
		end

	elseif generationMethod == "MultiColor" then
		-- 2-phase approach: color1 -> midColor, then midColor -> color2
		local half = math.floor(totalProps / 2)
		if half < 1 then half = 1 end

		for i, porp in ipairs(porpList) do
			if i <= half then
				-- from c1 -> midColor
				local t2 = (i - 1) / math.max(1, (half - 1))
				local adj = applyInterpolation(t2, "Linear")
				local r = c1.R + (midColor.R - c1.R) * adj
				local g = c1.G + (midColor.G - c1.G) * adj
				local b = c1.B + (midColor.B - c1.B) * adj
				porp.BackgroundColor3 = Color3.new(r, g, b)

				local label = porp:FindFirstChild("ColorCode_TextLabel")
				if label and label:IsA("TextLabel") then
					local rr = math.floor(r * 255)
					local gg = math.floor(g * 255)
					local bb = math.floor(b * 255)
					label.Text = string.format("#%02X%02X%02X", rr, gg, bb)
				end
			else
				-- from midColor -> c2
				local idx = i - half
				local span = math.max(1, (totalProps - half))
				local t2 = (idx - 1) / (span - 1)
				local adj = applyInterpolation(t2, "Linear")
				local r = midColor.R + (c2.R - midColor.R) * adj
				local g = midColor.G + (c2.G - midColor.G) * adj
				local b = midColor.B + (c2.B - midColor.B) * adj
				porp.BackgroundColor3 = Color3.new(r, g, b)

				local label = porp:FindFirstChild("ColorCode_TextLabel")
				if label and label:IsA("TextLabel") then
					local rr = math.floor(r * 255)
					local gg = math.floor(g * 255)
					local bb = math.floor(b * 255)
					label.Text = string.format("#%02X%02X%02X", rr, gg, bb)
				end
			end
		end
	else
		-- default to "Linear" if unknown
		for i, porp in ipairs(porpList) do
			local t = (i - 1) / (totalProps - 1)
			local adjustedT = applyInterpolation(t, "Linear")
			local r = c1.R + (c2.R - c1.R) * adjustedT
			local g = c1.G + (c2.G - c1.G) * adjustedT
			local b = c1.B + (c2.B - c1.B) * adjustedT
			porp.BackgroundColor3 = Color3.new(r, g, b)

			local label = porp:FindFirstChild("ColorCode_TextLabel")
			if label and label:IsA("TextLabel") then
				local rr = math.floor(r * 255)
				local gg = math.floor(g * 255)
				local bb = math.floor(b * 255)
				label.Text = string.format("#%02X%02X%02X", rr, gg, bb)
			end
		end
	end
end

return AdvancedGradientModule
--
