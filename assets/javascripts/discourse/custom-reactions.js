// custom-reactions.js

import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "custom-reactions-buttons",

  initialize(container) {
    withPluginApi("0.8", api => {
      api.decorateWidget("post-contents:after", dec => {
        const post = dec.getModel();

        return dec.h("div.custom-reactions-buttons", {}, [
          createReactionButton("👍 Çok Beğendim", "very_like", post.id),
          createReactionButton("🙂 Beğendim", "like", post.id),
          createReactionButton("🙁 Beğenmedim", "dislike", post.id),
          createReactionButton("👎 Hiç Beğenmedim", "very_dislike", post.id)
        ]);
      });
    });
  }
};

function createReactionButton(label, reactionType, postId) {
  return h("button.reaction-button", {
    onclick: () => {
      fetch("/custom-reactions/react", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
        },
        body: JSON.stringify({
          post_id: postId,
          reaction_type: reactionType
        })
      })
        .then(res => {
          if (!res.ok) throw new Error("Sunucu hatası");
          return res.json();
        })
        .then(json => {
          console.log("Tepki kaydedildi:", json);
        })
        .catch(err => {
          console.error("Tepki kaydedilemedi:", err);
        });
    }
  }, label);
}
