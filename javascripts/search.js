(function() {
  var $ = jQuery;

  $(function() {
    // Search URL ends: /search?q=mind
    var search_substr = window.location.search.substr(1);
    if(search_substr) {
      var search_term = search_substr.split('=')[1].toLowerCase();
      return $.getJSON('/search.json', function(data) {
        var i, j, k, len, len1, result, results, results1, value;
        results = [];
        for (j = 0, len = data.length; j < len; j++) {
          i = data[j];
          value = 0;
          if (i.title.toLowerCase().split(search_term).length - 1 !== 0) {
            value = 10;
          }
          if (i.content.toLowerCase().split(search_term).length - 1 !== 0) {
            value += (i.content.toLowerCase().split(search_term).length - 1) * 5;
          }
          if (value !== 0) {
            i.value = value;
            results.push(i);
          }
        }
        $('#search_results').html('');
        $('#results-title').append("<h2>Search Results for: '" + search_term + "'</h2>");
        if (results.length > 0) {
          results1 = [];
          for (k = 0, len1 = results.length; k < len1; k++) {
            result = results[k];
            results1.push($('#search_results').append('<li><a class="search-result" href="' + result.url + '">' + result.title + '</a> (' + result.type +')</li>'));
          }
          return results1;
        } else {
          $('#search_results').append('<p>No results found. Sorry.</p>');
        }
      });
    }
  });
}).call(this);
