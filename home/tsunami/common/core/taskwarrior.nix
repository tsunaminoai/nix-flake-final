{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    taskopen-custom
  ];
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    dataLocation = "~/.task";
    colorTheme = "dark-blue-256";
    config = {
      weekstart = "monday";
      default.command = "ready limit:page";
      search.case.sensitive = false;

      # List all projects with `task projects`, including those completed.
      list.all.projects = true;

      # Child tasks inherit their parent's urgency if that's higher.
      "urgency.inherit" = true;

      # How urgent something is depends upon what's waiting on it.
      urgency.blocking.coefficient = 0;
      urgency.blocked.coefficient = 0;

      # Dont make something higher just because I added notes to it
      urgency.annotations.coefficient = 0;

      # Make things for today and yesterday highter
      urgency.user.tag.today.coefficient = 2;
      urgency.user.tag.yesterday.coefficient = 3;

      # More sensible priority stack
      uda.priority.values = ["H" "M" "" "L"];
      urgency.uda.priority.L.coefficient = 0;
      "urgency.uda.priority..coefficient" = 1.8;

      # Costly tasks are most important.
      urgency.user.tag.costly.coefficient = 3.0;

      # Wife is more important than not-wife
      urgency.user.project.wife.coefficient = 1.0;

      # Fun and ideas are less important than not-fun
      urgency.user.project.fun.coefficient = -1.0;
      urgency.user.tag.fun.coefficient = -1.0;
      urgency.user.tag.idea.coefficient = -1.0;

      # relative priority adjustments
      urgency.tags.coefficient = 0;

      # recurring tasks' due dates aren't that important (especially before they're due)
      urgency.due.coefficient = 0.5;

      # turn off confirmations
      confirmation = false;
      bulk = 5;
      recurrence.confirmation = false;

      # stop prompting for news
      news.version = "2.6.0";

      context = {
        home = "project.not:work";
        work = "project:work";
        fun = "project:fun or +fun or +idea";
        focus = "-wife -INBOX project.not:wife project.not:social";
      };

      verbose = "blank,header,footnote,label,new-id,affected,edit,special,project,sync,unwait,recur";

      report = {
        scheduled = {
          description = "Scheduled tasks";
          columns = "id,start.age,entry.age,priority,project,tags,recur.indicator,scheduled.relative,due.relative,until.remaining,description.count,urgency";
          labels = "ID,Active,Age,P,Project,Tags,R,S,Due,Until,Description,Urg";
          sort = "scheduled";
          filter = "+SCHEDULED -COMPLETED -DELETED";
        };

        # Next: dont show annotations
        next = {
          columns = "id,start.age,entry.age,depends,priority,project,tags,recur,scheduled.countdown,due.relative,until.remaining,description.count,urgency";
        };

        # Ready: No Annotations. No Dependency Indicator
        ready = {
          columns = "id,start.age,entry.age,priority,project,tags,recur.indicator,scheduled.countdown,due.relative,until.remaining,description.count,urgency";
          labels = "ID,Active,Age,P,Project,Tags,R,S,Due,Until,Description,Urg";
        };

        # Completed: No Annotations
        completed = {
          columns = "id,uuid.short,entry,end,entry.age,depends,priority,project,tags,recur.indicator,due,description.count";
          labels = "ID,UUID,Created,Completed,Age,Deps,P,Project,Tags,R,Due,Description";
        };

        # Waiting: No annotations. No relative dates
        waiting = {
          labels = "ID,A,Age,D,P,Project,Tags,R,Waiting,Sched,Due,Until,Description";
          columns = "id,start.active,entry.age,depends.indicator,priority,project,tags,recur.indicator,wait.remaining,scheduled,due.relative,until,description.count";
          sort = "wait+,due+,entry+";
        };

        # Triage
        triage = {
          description = "Personal - To-Do";
          columns = "id,priority,start.active,urgency,due,description.desc,tags";
          labels = "ID,Pri,A,Urg,Due,Description,Tags";
          filter = "( proj: or proj:personal ) ( due.before:tomorrow or due: ) status:pending -WAITING -idea";
          sort = "urgency-";
        };

        # Today
        today = {
          description = "Tasks for Today";
          columns = "id,project,priority,start.active,urgency,due,description.desc,tags";
          labels = "ID,Proj,Pri,A,Urg,Due,Description,Tags";
          filter = "status:pending -BLOCKED -review and ( ( proj: and ( ( prio:H and due: ) or due.before:tomorrow or +respond or +today or +next or +inprogress or +yesterday) ) or +daytime )";
          sort = "urgency-";
        };

        active = {
          description = "Active Tasks";
          columns = "id,description.desc,tags";
          labels = "ID,Description,Tags";
          filter = "status:pending +ACTIVE";
          sort = "urgency-";
        };

        status = {
          description = "Status Table";
          #|Project|Description|Scheduled|Due|Status|
          columns = "project,description.desc,scheduled,due,status";
          labels = "Project,Description,Scheduled,Due,Status";
          sort = "urgency-,due-";
        };
        # lattice reports for pways
        lattice = {
          accomplished = {
            description = "Lattice Completed This Week for Passageways";
            columns = "project,priority,due,end,description";
            labels = "Project,Priority,Due,Finished,Description";
            filter = "status:completed pro:work and end.before:eoww and end.after:soww";
            sort = "end-";
          };
          upcoming = {
            description = "Lattice Upcoming Week for Passageways";
            columns = "project,priority,scheduled,due,description";
            labels = "Project,Priority,Scheduled,Due,Description";
            filter = "status:pending pro:work and ( due.before:eoww+1w or scheduled.before:eoww+1w) and (due.after:eoww or scheduled.after:eoww)";
            sort = "scheduled-,due-";
          };
        };
      };
    };
    extraConfig = ''
      include  ~/.config/task/taskchampion-sync
    '';
  };

  services.taskwarrior-sync =
    if pkgs.stdenv.hostPlatform.isLinux
    then {
      enable = true;
      frequency = "*:0/5";
    }
    else {};

  programs.fish.shellAliases = {
    t = "task";
    ts = "task sync";
    ta = "task add";
    tn = "task next";
    topen = "taskopen";
  };

  home.file.".config/taskopen/taskopenrc".text = ''
    [General]
    taskbin=task
    taskargs
    no_annotation_hook="addnote $ID"
    task_attributes="priority,project,tags,description"
    --sort:"urgency-,annot"
    --active-tasks:"+PENDING"
    EDITOR=nano
    path_ext="~/.local/share/taskopen/scripts"

    [Actions]
    files.target=annotations
    files.labelregex=".*"
    files.regex="^[\\.\\/~]+.*\\.(.*)"
    files.command="open $FILE"
    files.modes="batch,any,normal"
    notes.target=annotations
    notes.labelregex=".*"
    notes.regex="^Notes(\\..*)?"
    notes.command="""editobsidian $UUID"""
    notes.modes="batch,any,normal"
    url.target=annotations
    url.labelregex=".*"
    url.regex="((?:www|http).*)"
    url.command="open $LAST_MATCH"
    url.modes="batch,any,normal"

    obsidian.target=annotations
    obsidian.labelregex=".*"
    obsidian.regex="((?:obsidian).*)"
    obsidian.command="open $LAST_MATCH"
    obsidian.modes="batch,any,normal"

  '';

  home.file.".local/share/taskopen/scripts/editobsidian".text = ''
    #!/usr/bin/env bash
    # Opens a Notes file and creates a header if file does not exist.

    OBSIDIAN_VAULT=~/Documents/FalseBlue-Personal
    OBSIDIAN_TASK_DIR="taskwarrior/tasknotes"
    OBSIDIAN_API_KEY_FILE="${config.sops.secrets."obsidian/api-key".path}"
    OBSIDIAN_API_KEY=$(cat $OBSIDIAN_API_KEY_FILE)

    get_task_info() {
        task $1 export
    }

    write_to_obsidian() {
        UUID=$1
        TASK=$(get_task_info $UUID)

        tag_string=$(echo $TASK | jq -r '.[0].tags | join(", ")')

        title=$(echo $TASK | jq -r '.[0].description')
        taskid=$UUID
        project=$(echo $TASK | jq -r '.[0].project')

        markdown_block="---
    title: $title
    alias: $title
    taskid: $taskid
    project: $project
    tags: ''${tag_string}, $taskid
    ---

    # $title

    * [ ] $title
    "


        # send the markdown to Obsidian
        # https://coddingtonbear.github.io/obsidian-local-rest-api/
        curl -s \
        --insecure \
        -X POST \
        -H "Authorization: Bearer ''${OBSIDIAN_API_KEY}" \
        -H "Content-Type: text/markdown" \
        -d "''${markdown_block}" \
        "https://localhost:27124/vault/$OBSIDIAN_TASK_DIR/$1.md"
    }

    if [ $# -eq 1 ]; then
        FILE=$OBSIDIAN_VAULT/$OBSIDIAN_TASK_DIR/$1.md
        if [ ! -e $1 ]; then
            write_to_obsidian $1 $2
    	fi
        if [ ! -e $FILE ]; then
            echo "Couldnt create the file using REST"
            exit 1
        fi
        # open the file in the default editor
    	$EDITOR $FILE
    else
    	echo "Usage: $0 <uuid>"
    fi
  '';
}
