"use strict";

$(document).ready(function () {
  $("#course_course_number").keyup(function (event) {
    if (event.target.value.length == 5) {
      $("#spinner").show();
      var term = $("#course_term_id").val();
      var lookupUrl = event.target.attributes["lookup-url"].value;
      lookupUrl = lookupUrl.replace(":school_id", "1");
      lookupUrl = lookupUrl.replace(":term_id", term);
      lookupUrl = lookupUrl.replace(":course_number", event.target.value);
      $.ajax({url: lookupUrl,
        dataType: "json",
        success: function(classInfo) {
          $("#courseName").html(classInfo.name);
          $("#spinner").hide();
        },
        error: function(jqXHR, textStatus, errorThrown) {
          if (jqXHR.status == 404) {
            $("#courseName").html("Class not found");
          } else {
            $("#courseName").html("Error loading class title");
          }
          $("#spinner").hide();
        }
      });
    } else {
      $("#courseName").html("");
    }
  });
  $("course_term_code").change(function (event) {
    $("#course_course_number").val("");
    $("#courseName").html("");
  });

  $("#user_phone").change(function (event) {
    try {
      $("#phone-errors").html("");
      event.target.value = formatPhoneNumber(event.target.value);
    } catch (ex) {
      $("#phone-errors").html(ex.toString());
    }
  });

  $("#course_school_id").change(function (event) {
    var lookupUrl = event.target.attributes["get-terms-url"].value;
    lookupUrl = lookupUrl.replace(":school_id", event.target.value);
    $.ajax({url: lookupUrl,
      dataType: "json",
      success: function(terms) {
        // remove existing terms
        var select = $("#course_term_id")[0];
        while (select.length > 0) {
          select.remove(0);
        }
        for (var i = 0; i < terms.length; i++) {
          var option = document.createElement("option");
          option.value = terms[i].term_id;
          option.text = terms[i].name;
          select.add(option, null);
        }
      },
      error: function() {}});
  });
});

/**
 * borrowed from http://blog.stevenlevithan.com/archives/validate-phone-number
 */
function formatPhoneNumber(phoneNumber) {
  if (phoneNumber == "") {
    return phoneNumber;
  } else {
    var regexObj = /^\s*\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\s*$/;
	
    if (regexObj.test(phoneNumber)) {
      return phoneNumber.replace(regexObj, "$1-$2-$3");
    } else {
      throw new Error("The phone number is not valid");
    }
  }
}
