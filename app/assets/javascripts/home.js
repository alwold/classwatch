$(document).ready(function () {
  $("#course_course_number").keyup(function (event) {
    if (event.target.value.length == 5) {
      $("#spinner").show();
      var term = $("#course_term_id").val();
      $.ajax({url: "/classes/lookup/1/"+term+"/"+event.target.value,
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
