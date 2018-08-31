function syncValues() {
  from_selects = $("#push-rate-from > select");
  to_selects = $("#push-rate-to > select");

  if (to_selects.eq(0).val() < from_selects.eq(0).val() ||
      (to_selects.eq(0).val() == from_selects.eq(0).val() && to_selects.eq(1).val() < from_selects.eq(1).val()))
  {
    to_selects.eq(0).val(from_selects.eq(0).val());
    to_selects.eq(1).val(from_selects.eq(1).val());
  }
}

$(document).ready(function()
{
    $("#push-rate-from > select").change(function() {
      syncValues();
    });
    $("#push-rate-to > select").change(function() {
      syncValues();
    });
});
