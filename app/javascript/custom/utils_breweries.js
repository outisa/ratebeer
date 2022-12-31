const BREWERIES = {}

const handleResponse = (breweries) => {
  console.log('breweries', breweries)
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (brewery) => {
  const tr = document.createElement("tr")
  tr.classList.add("tablerow")
  const breweryname = tr.appendChild(document.createElement("td"));
  breweryname.innerHTML = brewery.name
  const breweryyear = tr.appendChild(document.createElement("td"));
  breweryyear.innerHTML = brewery.year
  const brewerybeers = tr.appendChild(document.createElement("td"));
  brewerybeers.innerHTML = brewery.beers.length
  const breweryactive = tr.appendChild(document.createElement("td"));
  breweryactive.innerHTML = brewery.active ? "" : "Retired";

  return tr;
};

BREWERIES.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("brewerytable");

  BREWERIES.list.forEach((brewery) => {
    const tr = createTableRow(brewery);
    table.appendChild(tr)
  });
};

const compare = (a, b) => {
  if (a < b) return -1
  if (b < a) return 1
  return 0
}
BREWERIES.sortByName = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  })
}

BREWERIES.sortByYear = () => {
  BREWERIES.list.sort((a, b) => {
    return compare(b.year, a.year);
  })
}

BREWERIES.sortByBeers = () => {
  BREWERIES.list.sort((a, b) => {
    return compare(b.beers.length, a.beers.length)
  })
}

const breweries = () => {
  if (document.querySelectorAll("#brewerytable").length < 1) return;

  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByName();
    BREWERIES.show();
  });

  document.getElementById("year").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByYear();
    BREWERIES.show();
  });

  document.getElementById("beers").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByBeers();
    BREWERIES.show();
  });

  fetch("breweries.json")
    .then((response) => response.json())
    .then(handleResponse);
};

export { breweries };
