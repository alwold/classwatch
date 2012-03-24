function validateNotifiers() {
  var foundSelected = false;
  $("input[name^=\"notifier_\"]").each(function(index, element) {
    if (element.checked) foundSelected = true;
  });
  if (!foundSelected) {
    $("#notifier-warnings").html("Disabling all notifiers will prevent you from being notified if a class is available!");
    $("#notifier-warnings").show();
  } else {
    $("#notifier-warnings").hide();
  }
}

$(document).ready(function () {
  $("input[name^=\"notifier_\"]").change(function(e) {
    validateNotifiers();
  });
});
