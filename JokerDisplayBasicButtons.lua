-- JokerDisplay Basic Buttons bridge
-- Requires: Basic Buttons + JokerDisplay
--
-- Adds a touch-friendly "JD" button to Joker cards.
-- Pressing it calls JokerDisplay's own Card:joker_display_toggle().

local function add_jd_button(center)
    if not center or center.set ~= "Joker" then return end

    center.buttons = center.buttons or {}

    -- Avoid adding the same bridge twice.
    for _, button in ipairs(center.buttons) do
        if button.__JDBB then return end
    end

    center.buttons[#center.buttons + 1] = {
        __JDBB = true,

        get_button_args = function(self, card)
            if not card or not card.joker_display_values then
                return nil
            end

            local hidden = card.joker_display_values.disabled

            return {
                id = "jdbb_joker_display",
                effect = "jdbb_toggle_joker_display",
                title = "JokerDisplay",
                text = hidden and "SHOW" or "HIDE",
                one_press = false,
                card = card,
            }
        end,

        hide = function(self, card)
            return not card or not card.joker_display_values
        end,
    }
end

G.FUNCS.jdbb_toggle_joker_display = function(e)
    local card = e and e.config and e.config.ref_table
    if not card or type(card.joker_display_toggle) ~= "function" then return end

    card:joker_display_toggle()

    -- Refresh the display nodes immediately when possible.
    local children = card.children
    if children then
        if children.joker_display then
            children.joker_display:recalculate(true)
        end
        if children.joker_display_small then
            children.joker_display_small:recalculate(true)
        end
        if children.joker_display_debuff then
            children.joker_display_debuff:recalculate(true)
        end
        if children.joker_display_perishable then
            children.joker_display_perishable:recalculate()
        end
        if children.joker_display_rental then
            children.joker_display_rental:recalculate()
        end
    end
end

-- Existing registered centers.
if G and G.P_CENTERS then
    for _, center in pairs(G.P_CENTERS) do
        add_jd_button(center)
    end
end

-- Also catch Joker centers registered after this bridge loads.
-- Steamodded's center registry is normally populated before this point,
-- so this is mainly defensive for unusual mod load orders.
if SMODS and SMODS.Joker and SMODS.Joker.take_ownership then
    -- Intentionally not overriding take_ownership globally.
    -- Existing centers are handled above; new Joker mods can be added by
    -- reloading this bridge or by the optional initialize hook below.
end

-- Catch the common case where a Joker is initialized after mod loading.
if Card and Card.initialize_joker_display then
    local old_initialize = Card.initialize_joker_display
    function Card:initialize_joker_display(...)
        add_jd_button(self.config and self.config.center)
        return old_initialize(self, ...)
    end
end
