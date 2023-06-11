//hint on left
settings.hintAlign = "left";
//return to N mode after yank
settings.modeAfterYank = "Normal";
//omnibar focus on first 
settings.omnibarSuggestion = true;
settings.focusFirstCandidate = false;
//focus on last visited tab after this tab is closed.
settings.focusAfterClosed = "right";
//show omnibar at bottom
settings.omnibarPosition = "top";

api.Hints.setCharacters('jklnmyuioph');

//SurfingKeys settings
// H, L for left / right tab
//api.map('H', 'h');
//api.map('L', 'l');
api.map('h', 'E'); 
api.map('l', 'R');

api.map('<Ctrl-k>', 'e');
api.map('<Ctrl-j>', 'd');
api.map('W', 'w');

// d to close tab
api.map('d', 'x');

//E, R for last / prev tab in history
api.map('E', 'B');
api.map('R', 'F');

//F to open new link in new active tab
api.map('F', 'af');

//H L for back/forward
api.map('H', 'S');
api.map('L', 'D');

//Space to open omnibar with tabs
api.mapkey('b', 'Choose a tab with omnibar', function() {
    api.Front.openOmnibar({type: "Tabs"});
});

//q to open at current tab
api.mapkey('q','Open an URL in current tab', function() {
    api.Front.openOmnibar({type: "URLs", extra: "getTopSites", tabbed: false});
});

//regex for thingid
const regex = new RegExp('^([0-9]+([a-zA-Z]+[0-9]+)+)$');
api.mapkey(',i', 'Open MX payment-int', function(){
    api.Clipboard.read(function(response) {
        var id = response.data;
        if (regex.test(id)) {
            api.tabOpenLink("https://payment-int.one-device-dashboard.bids.physical-stores.amazon.dev/#/devices/" + id);
        } else {
            api.tabOpenLink("https://payment-int.one-device-dashboard.bids.physical-stores.amazon.dev/#/devices/search");
        }
    });
});

api.mapkey(',x', 'Open MX payment-ext', function(){
    api.Clipboard.read(function(response) {
        var id = response.data;
        if (regex.test(id)){
            api.tabOpenLink("https://payment-ext.mx-internal.bids.physical-stores.amazon.dev/#/devices/" + id);
        } else {
            api.tabOpenLink("https://payment-ext.mx-internal.bids.physical-stores.amazon.dev/#/devices/search");
        }
    });
});

//S to switch to scrollable items. 
api.map('S', ';fs');

//scroll step size
settings.scrollStepSize = 240;

//enable smooth scroll
settings.smoothScroll = true;
//
// set theme
settings.theme = `
.sk_theme {
  font-family: SauceCodePro Nerd Font, Consolas, Menlo, monospace;
  font-size: 10pt;
  background: #f0edec;
  color: #2c363c;
}
.sk_theme tbody {
  color: #f0edec;
}
.sk_theme input {
  color: #2c363c;
}
.sk_theme .url {
  color: #1d5573;
}
.sk_theme .annotation {
  color: #2c363c;
}
.sk_theme .omnibar_highlight {
  color: #88507d;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: #f0edec;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: #cbd9e3;
}
#sk_status,
#sk_find {
  font-size: 10pt;
}
`;

// Link Hints
api.Hints.style (`
  font-family: monospace;
  font-size: 20px;
  font-weight: normal;
  text-transform: lowercase;
`);

// Text Hints
api.Hints.style (`
  font-family: monospace;
  font-size: 20px;
  text-transform: lowercase;
  `,
  "text"
);
