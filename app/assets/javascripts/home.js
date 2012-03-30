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
});
