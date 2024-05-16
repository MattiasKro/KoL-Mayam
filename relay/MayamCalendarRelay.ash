boolean checkAvailable(string itemString, boolean [string, string] available) {
    boolean result = true;
    string [int] items = split_string(itemString, ", "); // This will store items in an array, but the index wil not match ring #
    foreach key, itemName in items {
        string ring = "x" + to_string(4-key);
        result = result & available[ring, itemName];
    }
    return result;
}

string createYamButton(string title, string description, string icon, string items, boolean [string, string] available) {
    buffer button;

    string className = (checkAvailable(items, available)) ? "" : " disabled";
    button.append('<div data-yamdata="' + items + '" class="yam-button' + className + '" title="' + items + '" id="' + title + '">');
    button.append('<img src="/images/itemimages/' + icon + '" height="30" width="30">');
    button.append('<div class="yam-text">');
    button.append('<strong>' + title + '</strong>');
    button.append('<br>' + description + '</div></div>');

    return button;
}

string extractDiv(string source, string id) {
    string result = "";

    matcher divmatcher = create_matcher("(<div id=\"" + id + "\"*?</div>)", source);
    while (find(divmatcher)) {
        result = group(divmatcher, 1);
    }
    return result;
}


// <img data-pos="0" class="" alt="Yam" title="Yam" style="transform: rotate(0deg);" src="/images/otherimages/mayyam/yam.png">

boolean [string, string] parseAvailableSummons(string source) {
    boolean [string, string] availability;
    for x from 5 to 1 by -1 {
        string divName = "x" + to_string(x);
        matcher divmatcher = create_matcher("(<div id=\"" + divName + "\".*?</div>)", source);
        if (find(divmatcher)) {
            string subset = group(divmatcher, 1);
            matcher imgmatcher = create_matcher("<img .*? class=\"(.*?)\".*? title=\"(.*?) .*?>", subset);
            while (find(imgmatcher)) {
                string part = group(imgmatcher, 2);
                if (length(group(imgmatcher ,1)) > 0) {
                    availability[divname, part] = false;
                } else {
                    availability[divname, part] = true;
                }
            }
        }
    }
    return availability;
}

string fixAltTexts(string pageSource) {
    buffer fixedText = pageSource;

    string [string] conversionTable = {
        "Yam (outer ring)": "1F food, 4-5  adv",
        "Sword (outer ring)": "10 x lvl STR substats",
        "Vessel (outer ring)": "100 turns of Vessel of Magic (max MP +100, 2-12 MP regen) + 1000 MP",
        "Fur (outer ring)": "100 famxp",
        "Chair (outer ring)": "+5 free rests",
        "Eye (outer ring)": "100 turns of Big Eyes (+30% item drop)",
        "Yam (middle-outer ring)": "1F food, 4-5  adv",
        "Lightning (middle-outer ring)": "10 x lvl MYS substats",
        "Bottle (middle-outer ring)": "100 turns of Bottled Fortune (max HP +100, 15-20 HP regen)",
        "Wood (middle-outer ring)": "4 planks/fasteners",
        "Meat (middle-outer ring)": "100 x lvl meat ",
        "Yam (middle-inner ring)": "1F food, 4-5  adv",
        "Eyepatch (middle-inner ring)": "10 x lvl MOX substats",
        "Cheese (middle-inner ring)": "Goat Cheese",
        "Wall (middle-inner ring)": "100 turns of Walled In (+10 DR, +2 prismatic res)",
        "Yam (inner ring)": "1F food, 4-5  adv",
        "Clock (inner ring)": "+5 adventurs",
        "Explosion (inner ring)": "+5 fites",
    };

    foreach key, sub in conversionTable {
        fixedText.replace_string('title="' + key + '"', 'title="' + key + ': ' + sub + '"');
    }

    return fixedText;
}

string createRererenceTable(string [int, int] btnData, boolean [string, string] availability) {
    buffer table;

    table.append('<div class="section" style="width:95%"><div class="section-title"">Resonance Reference</div><div>');
    table.append('<table class="reftable"><tr class="reftable header"><td>Result</td><td>Ring 1</td><td>Ring 2</td><td>Ring 3</td><td>Ring 4</td></tr>');
    table.append('</div></div>');
    
    foreach key in btnData {
        table.append('<tr><td class="reftable result">');
        table.append('<img src="/images/itemimages/' + btnData[key][2] + '" height="20" width="20">');
        table.append(' ' + btnData[key][0] + '</td>');

        string [int] items = split_string(btnData[key][3], ", "); // This will store items in an array, but the index wil not match ring #
        foreach key, itemName in items {
          table.append('<td>' + itemName + '</td>');
        }
        table.append('</tr>');
    }
    
    table.append('</table>');

    return table;
}

string handleYamConsideration(string page_text) {
    string [int, int] buttonData = {
        {"Mayam spinach", "1 fullness food, 4 adv<br>50 turns of Weapon Damage +30", "spinachcan.gif", "Eye, Yam, Eyepatch, Yam"},
        {"Yam and swiss", "1 fullness food, 5 adv<br>100 meat + goat cheese", "hamsandwich.gif", "Yam, Meat, Cheese, Yam"},
        {"Yam Cannon", "<i>Melting</i> 1-handed ranged weapon, <font color='red'>+50 hot</font> damage, +25% ranged damage, +30% food drop", "yamgun.gif", "Sword, Yam, Eyepatch, Explosion"},
        {"Furry yam buckler", "<i>Melting</i> shield<br>+4 Cold Res, 11 DR<br>75% Prev. Negative Status Attacks", "yamshield.gif", "Fur, Yam, Wall, Yam"},
        {"Yamtility belt", "<i>Melting</i> accessory<br>+55% Meat from Monsters<br>Init +15%, Moxie +5%", "Yambelt.gif", "Yam, Meat, Eyepatch, Yam"},
        {"Tiny yam cannon", "<i>Melting</i> familiar equipment<br>Combat Initiative +50%<br>Gives your familiar an extra attack.", "Yamgun2.gif", "Fur, Lightning, Eyepatch, Yam"},
        {"Yam battery", "Usable (1 per day)<br>Restore up to 1,000 MP<br>Gain 3 Random Good Effects", "Yambattery.gif", "Yam, Lightning, Yam, Clock"},
        {"Stuffed yam stinkbomb", "Combat item<br>Banish a monster for 15 turns", "Yambomb2.gif", "Vessel, Yam, Cheese, Explosion"},
        {"Thanksgiving bomb", "Combat item<br>Deals 750-1000 Physical and <font color='red'>Hot</font> Damage", "yambomb.gif", "Yam, Yam, Yam, Explosion"},
        {"Caught Yam-Handed", "30 turns of sometimes blocking your opponent's attack", "Yam.gif", "Chair, Yam, Yam, Clock"},
        {"Memories of Cheesier Age", "30 turns of +100% Food Drops from Monsters, <font color='green'>+25 Stench</font> Damage", "yamcheese.gif", "Yam, Yam, Cheese, Clock"}
    };

    boolean [string, string] availability = parseAvailableSummons(page_text);

    buffer newPage;
    buffer rewardButtons;
    
    newPage.append(fixAltTexts(page_text));

    newPage.replace_string("</head>", "<script type=\"text/javascript\" src=\"Mayyam.js\"></script></head>");
    newPage.replace_string("</head>", '<link rel="stylesheet" type="text/css" href="Mayyam.css\"></head>');
    newPage.replace_string("<i>(Click a symbol to rotate the calendar.)</i>", ""); 

    rewardButtons.append('<div class="section" style="width:95%"><div class="section-title"">Resonances</div><div>');
    foreach key in buttonData {
        rewardButtons.append(createYamButton(buttonData[key][0], buttonData[key][1], buttonData[key][2], buttonData[key][3], availability));
    }
    rewardButtons.append('</div></div>');

    rewardButtons.append("<script>\n");
    rewardButtons.append('const buttons = document.querySelectorAll(".yam-button");\n');
    rewardButtons.append('buttons.forEach(button => { button.addEventListener("click", handleYam, true); });\n');
    rewardButtons.append("</script>\n");

// Excluded for now, didn't give enough benefit and looks ugly.
//    rewardButtons.append(createRererenceTable(buttonData, availability));

    int startPos = newPage.last_index_of("</table>");
    int endPos = newPage.last_index_of("</table>") + length("</table>");
    if (startPos > 0) {
        newPage.replace(startPos, endPos, "</table>" + rewardButtons);
    }

    return newPage;
}
