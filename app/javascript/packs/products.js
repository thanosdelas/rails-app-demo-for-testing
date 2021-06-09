"use strict";
/**
 * Use to manipulate search form submission and pagination
 */
const ProductsListing = function(){

	//
	// Search form element
	//
  var productsSearchForm = document.getElementById("prodcuts-search-form");

  //
  // Search input element
  //
  var searchInput = productsSearchForm.querySelectorAll('input[name="product_name"]');
  if(searchInput.length !== 1){
  	return alert("Could not find page input in form");
  }
  searchInput = searchInput[0];

  // Save current to compare later
  var currentSearch = searchInput.value;

  //
  // Page form input element
  //
  var pageInput = productsSearchForm.querySelectorAll('input[name="page"]');
  if(pageInput.length !== 1){
  	return alert("Could not find page input in form");
  }
  pageInput = pageInput[0];

  //
  // Search button
  //
  var searchButton = productsSearchForm.querySelectorAll('button[type="submit"]');
  if(searchButton.length !== 1){
  	// search button does not exist in form
  	return false;
  }
  searchButton = searchButton[0];
  searchButton.addEventListener("click", submitForm);

  //
  // Pagination element
  //
  var paginationElement = document.getElementById("pagination");
  if(paginationElement !== null){
		paginationElement.addEventListener("click", pagination);
  }

  function submitForm(e){

  	if(e){
  		e.preventDefault();
  	}

  	if(currentSearch !== searchInput.value){
			pageInput.value = "1";
  	}

    return productsSearchForm.submit();
  }

  function pagination(e){

  	if(e.target.getAttribute('data-page') === null){
  		return false;
  	}

  	pageInput.value = e.target.getAttribute('data-page');
  	return submitForm();
  }

  return {
  	submitForm: submitForm,
  	pagination: pagination
  }

}

const productsListing = new ProductsListing();
