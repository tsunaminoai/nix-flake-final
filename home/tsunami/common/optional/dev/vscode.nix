{...}: {
  programs.vscode = {
    mutableExtensionsDir = true;
    keybindings = [
      {
        command = "zig-language-extras.runFileTests";
        key = "ctrl+j t";
        when = "editorTextFocus && editorLangId == 'zig'";
      }
      # Zig extras: Run single test
      {
        command = "zig-language-extras.runSingleTest";
        key = "ctrl+j s";
        when = "editorTextFocus && editorLangId == 'zig'";
      }
      {
        key = "shift+cmd+p";
        command = "workbench.action.quickOpen";
      }
      {
        key = "cmd+p";
        command = "-workbench.action.quickOpen";
      }
      {
        key = "cmd+p";
        command = "workbench.action.showCommands";
      }
      {
        key = "shift+cmd+p";
        command = "-workbench.action.showCommands";
      }
    ];
    userSettings = {
      git.confirmSync = false;
      git.autofetch = true;
      terminal.integrated.enableMultiLinePasteWarning = false;
      editor.accessibilitySupport = "off";
      zig.path = "zig";
      explorer.confirmDragAndDrop = false;
      redhat.telemetry.enabled = false;
      githubPullRequests.createOnPublishBranch = "never";
      markdown.extension.orderedList.marker = "one";
      editor.fontFamily = "'Hack Nerd Font','DejaVu Sans Mono', Menlo, Monaco, 'Courier New', monospace";
      terminal.integrated.fontFamily = "'Hack Nerd Font','DejaVu Sans Mono', Menlo, Monaco, 'Courier New', monospace";
      github.copilot.enable = {
        "*" = true;
        plaintext = true;
        markdown = true;
        scminput = false;
        zig = true;
      };
      zig.zls.enableAutofix = true;
      zig.zls.enableBuildOnSave = true;
      workbench.settings.applyToAllProfiles = [
        "zig.zls.enableAutofix"
        "editor.tabSize"
      ];
      zig.initialSetupDone = true;
      editor.tabSize = 2;
      settingsSync.ignoredSettings = [
        "-zig.path"
        "-zig.zls.path"
      ];
      zig.formattingProvider = "zls";
      zig.buildOnSave = true;
      zig.zls.path = "zls";
      cmake.showOptionsMovedNotification = false;
      json = {
        editor.defaultFormatter = "vscode.json-language-features";
      };
      flake8.severity = {
        E = "Warning";
        F = "Warning";
      };
      jupyter.askForKernelRestart = false;
      github.copilot.editor.enableAutoCompletions = true;
      nix.enableLanguageServer = true;
    };
  };
}
