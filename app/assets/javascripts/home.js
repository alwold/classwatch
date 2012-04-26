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

  $("#school_id").change(function (event) {
    // remove existing terms
    var select = $("#course_term_id")[0];
    while (select.length > 0) {
      select.remove(0);
    }
    if (event.target.value != "") {
      var lookupUrl = event.target.attributes["get-terms-url"].value;
      lookupUrl = lookupUrl.replace(":school_id", event.target.value);
      $.ajax({url: lookupUrl,
        dataType: "json",
        success: function(data) {
          for (var i = 0; i < data['terms'].length; i++) {
            var option = document.createElement("option");
            option.value = data['terms'][i].term_id;
            option.text = data['terms'][i].name;
            select.add(option, null);
          }
          if (data['school'].schedule_link) {
            $("#schedule-link").attr("href", data['school'].schedule_link);
            $("#schedule-link").show();
          } else {
            $("#schedule-link").hide();
          }
          $("#school-specific").show();
        },
        error: function(jqXHR, textStatus, errorThrown) {
          alert("Error looking up terms: "+errorThrown.toString());
        }
      });
    } else {
      $("#school-specific").hide();
    }
  });

  // trigger the change event in case school is already populated, to set up the term select
  $("#school_id").change();
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
