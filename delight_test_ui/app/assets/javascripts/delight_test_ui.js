/**
 * Init functions
 */

var init = {
  //Init Run, Reset & Save button functionality
  action_buttons: function() {
    $('#run').click(function() {
      if ($(this).hasClass('inactive')) { return; }
      if (!$("#case-branches input:checked").length) { return alert('Please select one or more test cases.'); }
      
      toggleViews('#view-running');

      runScripts(function(json_results) {

        initResults("success", json_results);
        initResults("failure", json_results);

        var total_scripts = json_results["success"].length + json_results["failure"].length;
        var percentage_passed = (parseFloat(json_results["success"].length / total_scripts)*100);

        var title = percentage_passed.toFixed(2) + "% Passed";
        var subtitle = json_results["success"].length + "/" + total_scripts + " Tests";
        updateResultsHeaders(title, subtitle);

        toggleViews('#view-results');
        toggleButtonState(['#reset', '#save']);
      });

    });

    $('#reset').click(function() {
      if ($(this).hasClass('inactive')) { return; }

      if (confirm("Are you sure you want to reset your results?") == true) {
        toggleViews('#view-welcome');

        var title = "";
        var subtitle = "";
        updateResultsHeaders(title, subtitle);

        toggleButtonState(['#run']);
      }
    });

    $('#save').click(function() {
      if ($(this).hasClass('inactive')) { return; }

      toggleViews('#view-saved');
    });
  }, 

  //Init test case branches on left-hand side
  test_case_branches: function(test_cases) {
    var tc = test_cases.test_cases;
    var branches = '<ul>';

    for (i in tc) {
      branches += '<li id=' + tc[i].id + '>';
      branches += '<label class="outer-branch"><input data-case="' + tc[i].case + '" type="checkbox" /> ';      
      branches += tc[i].title;
      branches += '</label>';
      branches += '</li>';

      for (j in tc[i].cases) {
        branches += '<li class="'+tc[i].id+ ' indent" >';
  
        branches += '<label class="inner-branch"><input data-case="' + tc[i].cases[j].case + '" type="checkbox" /> ';
        branches += tc[i].cases[j].title;
        branches += '</label>';
  
        branches += '</li>';
      }
    }

    branches += '</ul>'

    $("#case-branches").html(branches);

    $(".outer-branch input").change(function() {
      var checked = this.checked;

      var id = $(this).closest("li").attr("id");
      $("." + id).find(".inner-branch input").prop("checked", checked);
    });
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

function initResults(result_type, json_results) {
  var li = "";
  var array_of_results = json_results[result_type]
  var counter = 0;

  if (!array_of_results.length) {
    $("#" + result_type).hide();
    return;
  } 
  
  $("#" + result_type).show();
  for (i in array_of_results) {
    counter++;

    li += "<li>";
    li += "<span class=title>" + counter + ". " + array_of_results[i].lead_state + " - " + array_of_results[i].test_name + "</span>";
    li += ": <br />";

    var msg = array_of_results[i].message;
    if ((typeof msg) === 'string') {
      msg = msg.replace(/\</g,"&lt;");
      msg = msg.replace(/\>/g,"&gt;");
    }

    msg = replaceAll("}; {","<br /><br />",msg);
    msg = replaceAll("\"Actual","<br />\"Actual",msg);
    msg = replaceAll("{","",msg);
    msg = replaceAll("};","",msg);
    msg = replaceAll("\"","",msg);
    msg = replaceAll(",","",msg);

    li += "<span class='message'>" + msg + "</span>";
    li += "</li>";
  }

  $("#" + result_type + " ul").html(li);
}

function onWelcomeScreen() {
  return $('#view-welcome').is(':visible');
}

function updateResultsHeaders(title, subtitle) {
  $("#view-results > h1 strong").html(title);
  $("#view-results > h2").html(subtitle);
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

function isJSON(str) {
  try {
    JSON.parse(str);
  } catch (e) {
    return false;
  }
  return true;
}

function replaceAll(find, replace, str) {
  return str.replace(new RegExp(find, 'g'), replace);
}

function runScripts(cb) {
  toggleButtonState(null);

  var params = "";
  $("#case-branches input:checked").each(function(index) {
    if ($(this).attr("data-case") !== "") {
      params += $(this).attr("data-case");

      if (index !== $("#case-branches input").length-1) {
        params += " "
      }
    }
  });

  $.post("/run_scripts.json", {
    params: params
  }, function(data) {
    var output = data.result;
    cb(JSON.parse(output));
  });
}