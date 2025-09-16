//
//  Action.js
//  ScoreAction
//
//  Created by Hao-Quan Liu on 2024/11/23.
//

var Action = function() {};

Action.prototype = {
    run: function(arguments) {
        arguments.completionFunction({
            "url": document.URL,
            "html": document.documentElement.outerHTML
        });
    }
};

var ExtensionPreprocessingJS = new Action;
