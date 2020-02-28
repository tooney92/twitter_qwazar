import consumer from "./consumer";

consumer.subscriptions.create("TweetChannel", {
  connected() {
    console.log("We are live");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var img = $('<img id="dynamic">');
    img.attr("src", data.post["image"]);
    img.attr("class", "rounded-circle");
    img.attr("width", "55px");
    img.attr("height", "55px");
    img.attr("style", "border:2");
    img.attr("draggable", "true");
    var p = $("<p class='card-text ml-2 mt-2'></p>");
    p.text(data.post["username"]);

    var div = $("<div id='tweet'></div>");
    var tweet_child_div = $("<div id='twt'></div>");
    var p_body = $("<p></p>");
    p_body.text(data.post["post"]);

    var div1 = $("<div class='card mb-3 '></div>");
    var div2 = $("<div class='card-body'></div>");
    var div3 = $("<div class='card-title title '></div>");
    var span = $("<span class='text-muted'></span>");
    span.text(" @" + data.post["username"] + " " + data.post["time"]);
    p.append(span);
    div3.append(img);
    div3.append(p);
    tweet_child_div.append(p_body);
    div.append(tweet_child_div);

    var icons = $("");
    div2.append(div3);
    div2.append(div);
    div1.append(div2);

    $(document)
      .find(".dambatta")
      .prepend(div1);
    console.log(data.post);
    // Called when there's incoming data on the websocket for this channel
  }
});
