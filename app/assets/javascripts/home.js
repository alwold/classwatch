"use strict";

$(document).ready(function () {
  // TODO the change event only triggers when the person goes out of field, etc. - not ideal
  $("#course_input_1,#course_input_2,#course_input_3").change(function (event) {
    var complete = true;
    var inputs;
    $("#course_input_1,#course_input_2,#course_input_3").each(function(index, element) {
      if (element.parentElement.style.display !== "none") {
        if (inputs) {
          inputs += "/"+element.value;
        } else {
          inputs = element.value;
        }
        if (!element.value) {
          complete = false;
        }
      }
    });
    if (complete) {
      $("#spinner").show();
      var term = $("#course_term_id").val();
      var lookupUrl = $("#course_input_1").attr("lookup-url");
      lookupUrl = lookupUrl.replace(":school_id", "1");
      lookupUrl = lookupUrl.replace(":term_id", term);
      lookupUrl = lookupUrl.replace(":inputs", inputs);
      $.ajax({url: lookupUrl,
        dataType: "json",
        success: function(classInfo) {
          if (classInfo.name) {
            $("#courseName").html(classInfo.name);
          } else if (classInfo.error) {
            $("#courseName").html(classInfo.error);
          }
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
    $("#course_input_1").val("");
    $("#course_input_2").val("");
    $("#course_input_3").val("");
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
    // TODO this is clearing out the data on initial load
    $("#course_input_1").val("");
    $("#course_input_2").val("");
    $("#course_input_3").val("");
    $("#courseName").html("");
    loadTerms(event.target.value, event.target.attributes["get-terms-url"].value);
  });

  // load terms in case school is already populated, to set up the term select
  loadTerms($("#school_id").val(), $("#school_id").attr("get-terms-url"), $("#current_term_id").val());
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

function loadTerms(schoolId, lookupUrl, currentTermId) {
  // remove existing terms
  var select = $("#course_term_id")[0];
  while (select.length > 0) {
    select.remove(0);
  }
  if (schoolId != "") {
    lookupUrl = lookupUrl.replace(":school_id", schoolId);
    $.ajax({url: lookupUrl,
      dataType: "json",
      success: function(data) {
        for (var i = 0; i < data['terms'].length; i++) {
          var option = document.createElement("option");
          option.value = data['terms'][i].term_id;
          option.text = data['terms'][i].name;
          if (currentTermId && currentTermId == option.value) {
            option.selected = true;
          }
          select.add(option, null);
        }
        if (data['school'].schedule_link) {
          $("#schedule-link").attr("href", data['school'].schedule_link);
          $("#schedule-link").show();
        } else {
          $("#schedule-link").hide();
        }
        if (data['school'].input_1_name) {
          $("#input-1-name").html(data['school'].input_1_name);
        } else {
          $("#input-1-name").html("Course Number");
        }
        if (data['school'].input_2_name) {
          $("#input-2-container").show();
          $("#input-2-name").html(data['school'].input_2_name);
        } else {
          $("#input-2-container").hide();
        }
        if (data['school'].input_3_name) {
          $("#input-3-container").show();
          $("#input-3-name").html(data['school'].input_3_name);
        } else {
          $("#input-3-container").hide();
        }
        if (data['school'].help_file) {
          $("#course-number-help-content").load("/help/"+data['school'].help_file+".html");
          $("#course-number-help-button").show();
        } else {
          $("#course-number-help-button").hide();
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
}
