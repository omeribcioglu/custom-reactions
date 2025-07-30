// user-score-badge.js

import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "custom-user-score-badge",

  initialize() {
    withPluginApi("0.8", api => {
      api.decorateWidget("poster-name:after", dec => {
        const user = dec.getModel()?.user;
        const scoreRaw = user?.custom_fields?.user_score;
        const score = parseInt(scoreRaw || 0);

        return dec.h("span.user-score-badge", {
          style: "margin-left: 8px; padding: 2px 6px; background: #e0e0e0; border-radius: 8px; font-size: 0.75rem; font-weight: bold; color: #333;"
        }, `Puan: ${score}`);
      });
    });
  }
};
