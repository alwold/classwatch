function validateNotifiers() {
  var foundSelected = false;
  $("input[name^=\"notifier_\"]").each(function(index, element) {
    if (element.checked) foundSelected = true;
  });
  if (!foundSelected) {
    confirm("Disabling all notifiers will prevent you from being notified if a class is available!");
  }
}

$(document).ready(function () {
  $("input[name^=\"notifier_\"]").change(function(e) {
    validateNotifiers();
  });
});
