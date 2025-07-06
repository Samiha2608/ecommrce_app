import algoliasearch from "https://cdn.jsdelivr.net/npm/algoliasearch@4/+esm";
import { autocomplete } from "https://cdn.jsdelivr.net/npm/@algolia/autocomplete-js/+esm";

const client = algoliasearch("158RAXAE0S", "6a4b9873edab061808a6b2d8ebf98e3c");
const index  = client.initIndex("Product");    

document.addEventListener("turbo:load", () => {
  const container = document.querySelector("#navbar-search");
  if (!container) return;

  autocomplete({
    container,
    placeholder: "Search products…",
    getSources({ query }) {
      if (query.length < 2) return [];
      return [{
        sourceId: "products",
        getItems() {
          return index.search(query, { hitsPerPage: 5 }).then(r => r.hits);
        },
        templates: {
          item({ item }) {
            return item.product_name;
          }
        },
        onSelect({ item }) {
          window.location = `/products/${item.objectID}`; 
        }
      }];
    }
  });
});
