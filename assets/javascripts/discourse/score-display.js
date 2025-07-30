// score-display.js

import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "custom-reactions-score-display",

  initialize() {
    withPluginApi("0.8", api => {
      api.decorateWidget("post-contents:after", dec => {
        const post = dec.getModel();
        const topicScore = post.topic.custom_fields?.topic_score;

        if (typeof topicScore === "undefined") return;

        return dec.h("div.topic-score-display", {
          style: "margin-top: 5px; font-weight: bold; color: #666;"
        }, `Toplam Puan: ${topicScore}`);
      });
    });
  }
};