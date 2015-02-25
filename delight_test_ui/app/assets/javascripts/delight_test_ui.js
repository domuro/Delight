/**
 * Init functions
 */

var init = {
  //Init Run, Reset & Save button functionality
  action_buttons: function() {
    $('#run').click(function() {
      if ($(this).hasClass('inactive')) { return; }

      toggleViews('#view-running');

      runScripts(function() {
        toggleViews('#view-results');
        toggleButtonState(['#reset', '#save']);
      });

    });

    $('#reset').click(function() {
      if ($(this).hasClass('inactive')) { return; }

      if (confirm("Are you sure you want to reset your results?") == true) {
        toggleViews('#view-welcome');
        toggleButtonState(['#run']);
      }
    });

    $('#save').click(function() {
      if ($(this).hasClass('inactive')) { return; }

      toggleViews('#view-saved');
    });
  }, 

  //Init test case branches on left-hand side
  //TODO: Make this recursive
  test_case_branches: function(test_cases) {
    var tc = test_cases.test_cases;
    var branches = '<ul>';

    for (i in tc) {
      branches += '<li>';
      branches += '<label class="outer-branch"><input type="checkbox" /> ';
      branches += tc[i].title;
      branches += '</label>';
      branches += '</li>';

      for (j in tc[i].cases) {
        branches += '<li>';
        branches += '<ul>';

        branches += '<li>';
        branches += '<label class="inner-branch"><input type="checkbox" /> ';
        branches += tc[i].cases[j].title;
        branches += '</label>';
        branches += '</li>';

        branches += '</ul>'
        branches += '</li>';
      }
    }

    branches += '</ul>'

    $("#case-branches").html(branches);
  }
}


/**
 * On document ready
 */

$(document).ready(function() {
  var test_cases = JSON.parse(gon.test_cases);

  init.action_buttons();
  init.test_case_branches(test_cases);
});


/**
 * Helper Functions
 */

//If no buttonToMakeActive, all become inactive
function toggleButtonState(buttonsToMakeActive) {
  var buttons = ['#run', '#reset', '#save'];

  //First reset all button
  buttons.forEach(function(button) {
    $(button).addClass('inactive');
    $(button).removeClass('active');
  });

  if (buttonsToMakeActive) {
    buttonsToMakeActive.forEach(function(button) {
      $(button).addClass('active');  
      $(button).removeClass('inactive');  
    });
  }
}

function onWelcomeScreen() {
  return $('#view-welcome').is(':visible');
}

function toggleViews(viewToShow) {
  if ($(viewToShow).is(':visible')) { return; }

  var views = ['#view-welcome', '#view-running', '#view-results', '#view-saved'];

  views.forEach(function(view) {
    if (viewToShow === view) {
      $(view).show();
    } else {
      $(view).hide();
    }
  });
};

function runScripts(cb) {
  //TODO: Implement
  
  toggleButtonState(null);

  setTimeout(function() {
    cb();
  }, 5000);
}