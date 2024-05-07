string createYamButton(string title, string description, string icon, string items) {
    buffer button;

    button.append('<div data-yamdata="' + items + '" class="yam-button" title="' + items + '" id="' + title + '">');
    button.append('<img src="/images/itemimages/' + icon + '" height="30" width="30">');
    button.append('<div class="yam-text">');
    button.append('<strong>' + title + '</strong>');
    button.append('<br>' + description + '</div></div>');

    return button;
}

string handleYamConsideration(string page_text) {
    string [int, int] buttonData = {
        {"Mayam spinach", "1 fullness food, 4 adv<br>50 turns of Weapon Damage +30", "spinachcan.gif", "Eye, Yam, Eyepatch, Yam"},
        {"yam and swiss", "1 fullness food, 5 adv<br>100 meat + goat cheese", "hamsandwich.gif", "Yam, Meat, Cheese, Yam"},
        {"Yam Cannon", "<i>Melting</i> 1-handed ranged weapon, <font color='red'>+50 hot</font> damage, +25% ranged damage, +30% food drop", "yamgun.gif", "Sword, Yam, Eyepatch, Explosion"},
        {"furry yam buckler", "<i>Melting</i> shield<br>+4 Cold Res, 11 DR<br>75% Prev. Negative Status Attacks", "yamshield.gif", "Fur, Yam, Wall, Yam"},
        {"yamtility belt", "<i>Melting</i> accessory<br>+55% Meat from Monsters<br>Init +15%, Moxie +5%", "Yambelt.gif", "Yam, Meat, Eyepatch, Yam"},
        {"tiny yam cannon", "<i>Melting</i> familiar equipment<br>Combat Initiative +50%<br>Gives your familiar an extra attack.", "Yamgun2.gif", "Fur, Lightning, Eyepatch, Yam"},
        {"yam battery", "Usable (1 per day)<br>Restore up to 1,000 MP<br>Gain 3 Random Good Effects", "Yambattery.gif", "Yam, Lightning, Yam, Clock"},
        {"stuffed yam stinkbomb", "Combat item<br>Banish a monster for 15 turns", "Yambomb2.gif", "Vessel, Yam, Cheese, Explosion"},
        {"thanksgiving bomb", "Combat item<br>Deals 750-1000 Physical and <font color='red'>Hot</font> Damage", "yambomb.gif", "Yam, Yam, Yam, Explosion"},
        {"Caught Yam-Handed", "30 turns of sometimes blocking your opponent's attack", "Yam.gif", "Chair, Yam, Yam, Clock"},
        {"Memories of Cheesier Age", "30 turns of +100% Food Drops from Monsters, <font color='green'>+25 Stench</font> Damage", "yamcheese.gif", "Yam, Yam, Cheese, Clock"}
    };

    buffer newPage;
    buffer rewardButtons;
    
    newPage.append(page_text);
    newPage.replace_string("</head>", "<script type=\"text/javascript\" src=\"Mayyam.js\"></script></head>");
    newPage.replace_string("</head>", '<link rel="stylesheet" type="text/css" href="Mayyam.css\">');
    newPage.replace_string("<i>(Click a symbol to rotate the calendar.)</i>", ""); 

    rewardButtons.append('<div class="section" style="width:95%"><div class="section-title"">Resonances</div><div>');
    foreach key in buttonData {
        rewardButtons.append(createYamButton(buttonData[key][0], buttonData[key][1], buttonData[key][2], buttonData[key][3]));
    }
    rewardButtons.append('</div></div>');

    rewardButtons.append("<script>");
    rewardButtons.append('const buttons = document.querySelectorAll(".yam-button");');
    rewardButtons.append('buttons.forEach( function(button) {');
    rewardButtons.append('  button.addEventListener("click", function(event) {');
    rewardButtons.append('  const source = event.target || event.srcElement;');        
    rewardButtons.append('    handleYam(source);');
    rewardButtons.append('  });');
    rewardButtons.append('});');
    rewardButtons.append("</script>");

    int startPos = newPage.last_index_of("</table>");
    int endPos = newPage.last_index_of("</table>") + length("</table>");
    if (startPos > 0) {
        newPage.replace(startPos, endPos, "</table>" + rewardButtons);
    }

    return newPage;
}
