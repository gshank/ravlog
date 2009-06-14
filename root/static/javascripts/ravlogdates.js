function show_dates_as_local_time() {
  var spans = document.getElementsByTagName('span');
  for (var i=0; i<spans.length; i++) {
    if (spans[i].className.match(/nifty_date/i)) {
      spans[i].innerHTML = get_local_time_for_date(spans[i].title);
    }
  }
}

function get_local_time_for_date(time) {
  system_date = new Date(time);
  user_date = new Date();

//hacky as hell using regexp to extract from string and feed it back.
user_date = new Date().toGMTString();
regexp = /, (.*?) (.*?) (\d\d\d\d) (\d\d):(\d\d):(\d\d)/;
times = regexp.exec(user_date);
user_date = new Date(times[2]+' '+times[1]+', '+times[3]+' '+times[4]+':'+times[5]+':'+times[6]);

  delta_minutes = Math.floor((user_date- system_date) / (60 * 1000));
  if (Math.abs(delta_minutes) <= (8*7*24*60)) { // eight weeks... I'm lazy to count days for longer than that
    distance = distance_of_time_in_words(delta_minutes);
    if (delta_minutes < 0) {
      return distance + ' from now';
    } else {
      return distance + ' ago';
    }
  } else {
    return 'on ' + system_date.toLocaleDateString();
  }
}

// a vague copy of rails' inbuilt function, 
// but a bit more friendly with the hours.
function distance_of_time_in_words(minutes) {
  if (minutes.isNaN) return "";
  minutes = Math.abs(minutes);
  if (minutes < 1) return ('less than a minute');
  if (minutes < 50) return (minutes + ' minute' + (minutes == 1 ? '' : 's'));
  if (minutes < 90) return ('about one hour');
  if (minutes < 1080) return (Math.round(minutes / 60) + ' hours');
  if (minutes < 1440) return ('one day');
  if (minutes < 2880) return ('about one day');
  else return (Math.round(minutes / 1440) + ' days')
}
