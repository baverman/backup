(function () {
    let container = document.querySelector('div.lane-content');
    let cards = {};
    let years = [];
    for(let t of document.querySelectorAll('div.material-card[data-type="album"] .sub-title')) {
        let card = t.closest('div.material-card[data-type="album"]');
        let year = parseInt(t.text);
        let ycards = [];
        if (year in cards) {
            ycards = cards[year];
        } else {
            cards[year] = ycards;
        }
        ycards.push(card);
        years.push(year);
        card.remove();
    }

    years.sort();

    for(let year of years) {
        for(let c of cards[year]) {
            container.append(c);
        }
    }
})();
