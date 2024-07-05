{
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  cfg = config.${namespace}.home.taskwarrior;
in {
  options.tsunaminoai.home.taskwarrior = with lib.types; {
    enable = lib.mkEnableOption "Enable Taskwarrior";
    withTaskOpen = lib.mkEnableOption "Enable TaskOpen";
    withObsidian = lib.mkEnableOption "Enable Obsidian Integration";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      tsunaminoai.sops.secrets = {
        "taskchampion/tsunami" = {
          path = ".config/task/taskchampion-sync";
          mode = "0400";
        };
      };

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
    })
    (lib.mkIf (cfg.withTaskOpen && cfg.enable) {
      home.packages = with pkgs; [
        taskopen-custom
      ];
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
    })
    (lib.mkIf (cfg.withTaskOpen && cfg.enable && cfg.withObsidian) {
      tsunaminoai.sops.secrets = [
        {
          name = "obsidian/api-key";
          path = ".config/obsidian/api-key";
        }
      ];

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
    })
    {
      lib.snowfall.
      home.file.".config/fish/completions/task.fish".text = ''
          # Taskwarrior completions for the Fish shell <https://fishshell.com>
        #
        # taskwarrior - a command line task list manager.
        #
        # Completions should work out of box. If it isn't, fill the bug report on your
        # operation system bug tracker.
        #
        # As a workaround you can copy this script to
        # ~/.config/fish/completions/task.fish, and open a new shell.
        #
        # Objects completed:
        #  * Commands
        #  * Projects
        #  * Priorities
        #  * Tags
        #  * Attribute names and modifiers
        #
        #
        # You can override some default options in your config.fish:
        #
        # # Tab-completion of task descriptions.
        # # Warning: This often creates a list of suggestions which spans several pages,
        # # and it usually pushes some of the commands and attributes to the end of the
        # # list.
        # set -g task_complete_task yes
        #
        # # Tab-completion of task IDs outside of the "depends" attribute.
        # # Warning: This often creates a list of suggestions which spans several pages,
        # # and it pushes all commands and attributes to the end of the list.
        # set -g task_complete_id yes
        #
        # # Attribute modifiers (DEPRECATED since 2.4.0)
        # set -g task_complete_attribute_modifiers yes
        #
        #
        # Copyright 2014 - 2021, Roman Inflianskas <infroma@gmail.com>
        #
        # Permission is hereby granted, free of charge, to any person obtaining a copy
        # of this software and associated documentation files (the "Software"), to deal
        # in the Software without restriction, including without limitation the rights
        # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        # copies of the Software, and to permit persons to whom the Software is
        # furnished to do so, subject to the following conditions:
        #
        # The above copyright notice and this permission notice shall be included
        # in all copies or substantial portions of the Software.
        #
        # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        # OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
        # THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        # SOFTWARE.
        #
        # https://www.opensource.org/licenses/mit-license.php

        # NOTE: remember that sed on OS X is different in some aspects. E.g. it does
        #       not understand \t for tabs.

        # convinience functions

        function __fish.task.log
          for line in $argv
            echo $line >&2
          end
        end

        function __fish.task.partial
          set wrapped $argv[1]
          set what $argv[2]
          set -q argv[3]; and set f_argv $argv[3..-1]
          set f __fish.task.$wrapped.$what
          functions -q $f; and eval $f $f_argv
        end

        function __fish.task.zsh
          set -q argv[2]; and set task_argv $argv[2..-1]
          task _zsh$argv[1] $task_argv | sed 's/:/	/'
        end


        # command line state detection

        function __fish.task.bare
          test (count (commandline -c -o)) -eq 1
        end

        function __fish.task.current.command
          # find command in commandline by list intersection
          begin; commandline -pco; and echo $__fish_task_static_commands; end | sort | uniq -d | xargs
        end

        function __fish.task.before_command
          test -z (__fish.task.current.command)
        end


        # checking need to complete

        function __fish.task.need_to_complete.attr_name
          __fish.task.need_to_complete.filter; or contains (__fish.task.current.command) (__fish.task.list.command_mods)
        end

        function __fish.task.need_to_complete.attr_value
          __fish.task.need_to_complete.attr_name
          or return 1
          # only start completion when there's a colon in attr_name
          set -l cmd (commandline -ct)
          string match -q -- "*:*" "$cmd[-1]"
        end

        function __fish.task.need_to_complete.command
          switch $argv
            case all
              __fish.task.bare
            case filter
              __fish.task.before_command
          end
        end

        function __fish.task.need_to_complete.config
          contains (__fish.task.current.command) 'config' 'show'
        end

        function __fish.task.need_to_complete.context
          contains (__fish.task.current.command) 'context'
        end

        function __fish.task.need_to_complete.filter
          __fish.task.before_command
        end

        function __fish.task.need_to_complete.tag
          __fish.task.need_to_complete.attr_name
          or return 1
          set -l cmd (commandline -ct)
          # only start complete when supplied + or -
          string match -qr -- "^[+-][^+-]*" "$cmd[-1]"
        end

        function __fish.task.need_to_complete.id
          __fish.task.need_to_complete.filter
        end

        function __fish.task.need_to_complete.task
          __fish.task.need_to_complete.filter
        end

        function __fish.task.need_to_complete
          __fish.task.partial need_to_complete $argv
        end


        # list printers

        function __fish.task.token_clean
          sed 's/[^a-z_.]//g; s/^\.$//g'
        end

        function __fish.task.list.attr_name
          # # BUG: doesn't support file completion
          for attr in (task _columns)
            if set -l idx (contains -i -- $attr $__fish_task_static_attr_desc_keys)
              # use builtin friendly description
              echo -e "$attr:\tattribute:$__fish_task_static_attr_desc_vals[$idx]"
            else
              echo -e "$attr:\tattribute"
            end
          end
          echo -e "rc\tConfiguration for taskwarrior"
        end

        function __fish.task.list.attr_value
          set token (commandline -ct | cut -d ':' -f 1 | cut -d '.' -f 1 | __fish.task.token_clean)
          if test -n $token
            set attr_names (__fish.task.list.attr_name | sed 's/:	/	/g' | grep '^'$token | cut -d '	' -f 1)
            for attr_name in $attr_names
              if test -n $attr_name
                __fish.task.list.attr_value_by_name $attr_name
              end
            end
          end
        end

        function __fish.task.list.attr_value_by_name
          set attr $argv[1]
          switch $attr
            case 'rc'
              __fish.task.list.rc
            case 'depends' 'limit' 'priority' 'status'
              __fish.task.combos_simple $attr (__fish.task.list $attr)
            case 'recur'
              __fish.task.combos_simple $attr (__fish.task.list.date_freq)
            case 'due' 'until' 'wait' 'entry' 'end' 'start' 'scheduled'
              __fish.task.combos_simple $attr (__fish.task.list.dates)
            # case 'description' 'project'
            case '*'
              if [ "$task_complete_attribute_modifiers" = 'yes' ]; and echo (commandline -ct) | grep -q '\.'
                __fish.task.combos_with_mods $attr (__fish.task.list $attr)
              else
                __fish.task.combos_simple $attr (__fish.task.list $attr)
              end
          end
        end

        function __fish.task.list._command
          echo -e $__fish_task_static_commands_with_desc
        end

        function __fish.task.list.command
          # ignore special commands
          __fish.task.list._command $argv | command grep -Ev '^_'
        end

        function __fish.task.list.command_mods
          echo -e $__fish_task_static_command_mods
        end

        function __fish.task.list.config
          task _config
        end

        function __fish.task.list.context
          task _context
        end

        function __fish.task.list.depends
          __fish.task.list.id with_description
        end

        function __fish.task.list.description
          __fish.task.zsh ids $argv | awk -F"\t" '{print $2 "\tid=" $1}'
        end

        function __fish.task.list.id
          set show_type $argv[1]
          if test -z $show_type
            task _ids
          else if [ $show_type = 'with_description' ]
            __fish.task.zsh ids
          end
        end

        function __fish.task.list.date_freq
          set -l cmd (commandline -ct)
          if set -l user_input_numeric (echo $cmd[-1] | grep -o '[0-9]\+')
            # show numeric freq like 2d, 4m, etc.
            echo -e (string replace --all -r "^|\n" "\n$user_input_numeric" $__fish_task_static_freq_numeric | string collect)
          else
            echo -e $__fish_task_static_freq
          end
        end

        function __fish.task.list.dates
          set -l cmd (commandline -ct)
          if set -l user_input_numeric (echo $cmd[-1] | grep -o '[0-9]\+')
            # show numeric date like 2hrs, 4th, etc.
            echo -e (string replace --all -r "^|\n" "\n$user_input_numeric" $__fish_task_static_reldates | string collect)
            # special cases for 1st, 2nd and 3rd, and 4-0th
            set -l suffix 'th' '4th, 5th, etc.'
            if string match -q -- "*1" $user_input_numeric
              set suffix 'st' 'first'
            else if string match -q -- "*2" $user_input_numeric
              set suffix 'nd' 'second'
            else if string match -q -- "*3" $user_input_numeric
              set suffix 'rd' 'third'
            end
            echo -e $user_input_numeric"$suffix[1]\t$suffix[2]"
          else
            echo -e $__fish_task_static_dates
          end
        end

        # Attribure modifiers (DEPRECATED since 2.4.0)
        function __fish.task.list.mod
          echo -e $__fish_task_static_mod
        end

        function __fish.task.list.priority
          echo -e $__fish_task_static_priority
        end

        function __fish.task.list.project
          task _projects
        end

        function __fish.task.list.rc
          task _config
        end

        function __fish.task.list.status
          echo -e $__fish_task_static_status
        end

        function __fish.task.list.tag
          set -l tags (task _tags)
          printf '+%s\n' $tags
          # compatibility, older fish won't allow - in format
          printf ' %s\n' $tags | tr ' ' '-'
        end

        function __fish.task.list.task
          __fish.task.zsh ids | sed -E 's/^(.*)	(.*)$/\2	task [id = \1]/g'
        end

        function __fish.task.list
          __fish.task.partial list $argv
        end

        function __fish.task.results_var_name
          echo $argv | sed 's/^/__fish.task.list /g; s/$/ results/g; s/[ .]/_/g;'
        end

        function __fish.task.list_results
          set var_name (__fish.task.results_var_name $name)
          for line in $$var_name
            echo $line
          end
        end


        # working with attributes

        function __fish.task.combos_simple
          set attr_name $argv[1]
          set -q argv[2]; and set attr_values $argv[2..-1]
          if [ (count $attr_values) -gt 0 ]
            for attr_value in $attr_values
              echo "$attr_name:$attr_value"
            end
          else
            echo "$attr_name:"
          end
        end

        # Attribure modifiers (DEPRECATED since 2.4.0)
        function __fish.task.combos_with_mods
          __fish.task.combos_simple $argv
          for mod in (__fish.task.list.mod)
            __fish.task.combos_simple $argv[1].$mod $argv[2..-1]
          end
        end


        # actual completion

        function __fish.task.complete
          set what $argv
          set list_command "__fish.task.list $what"
          set check_function "__fish.task.need_to_complete $what"
          complete -c task -u -k -f -n $check_function -a "(eval $list_command)"
        end

        # static variables that won't changes even when taskw's data is modified
        set __fish_task_static_commands_with_desc (__fish.task.zsh commands | sort | string collect)
        set __fish_task_static_commands (echo -e $__fish_task_static_commands_with_desc | cut -d '	' -f 1 | string collect)
        set __fish_task_static_command_mods (printf '%s\n' 'add' 'annotate' 'append' 'delete' 'done' 'duplicate' 'log' 'modify' 'prepend' 'start' 'stop' | string collect)
        set __fish_task_static_mod (printf '%s\n' 'before' 'after' 'over' 'under' 'none' 'is' 'isnt' 'has' 'hasnt' 'startswith' 'endswith' 'word' 'noword' | string collect)
        set __fish_task_static_status (printf '%s\tstatus\n' 'pending' 'completed' 'deleted' 'waiting' | string collect)
        set __fish_task_static_priority (printf '%s\n' 'H\tHigh' 'M\tMiddle' 'L\tLow' | string collect)

        set __fish_task_static_freq 'daily:Every day' \
                                    'day:Every day' \
                                    'weekdays:Every day skipping weekend days' \
                                    'weekly:Every week' \
                                    'biweekly:Every two weeks' \
                                    'fortnight:Every two weeks' \
                                    'monthly:Every month' \
                                    'quarterly:Every three months' \
                                    'semiannual:Every six months' \
                                    'annual:Every year' \
                                    'yearly:Every year' \
                                    'biannual:Every two years' \
                                    'biyearly:Every two years'
        set __fish_task_static_freq (printf '%s\n' $__fish_task_static_freq | sed 's/:/\t/' | string collect)
        set __fish_task_static_freq_numeric 'd:days' \
                                            'w:weeks' \
                                            'q:quarters' \
                                            'y:years'
        set __fish_task_static_freq_numeric (printf '%s\n' $__fish_task_static_freq_numeric | sed 's/:/\t/' | string collect)
        set __fish_task_static_freq_numeric 'd:days' \
                                            'w:weeks' \
                                            'q:quarters' \
                                            'y:years'
        set __fish_task_static_freq_numeric (printf '%s\n' $__fish_task_static_freq_numeric | sed 's/:/\t/' | string collect)
        set __fish_task_static_dates 'today:Today' \
                                     'yesterday:Yesterday' \
                                     'tomorrow:Tomorrow' \
                                     'sow:Start of week' \
                                     'soww:Start of work week' \
                                     'socw:Start of calendar week' \
                                     'som:Start of month' \
                                     'soq:Start of quarter' \
                                     'soy:Start of year' \
                                     'eow:End of week' \
                                     'eoww:End of work week' \
                                     'eocw:End of calendar week' \
                                     'eom:End of month' \
                                     'eoq:End of quarter' \
                                     'eoy:End of year' \
                                     'mon:Monday' \
                                     'tue:Tuesday'\
                                     'wed:Wednesday' \
                                     'thu:Thursday' \
                                     'fri:Friday' \
                                     'sat:Saturday' \
                                     'sun:Sunday' \
                                     'goodfriday:Good Friday' \
                                     'easter:Easter' \
                                     'eastermonday:Easter Monday' \
                                     'ascension:Ascension' \
                                     'pentecost:Pentecost' \
                                     'midsommar:Midsommar' \
                                     'midsommarafton:Midsommarafton' \
                                     'later:Later' \
                                     'someday:Some Day'
        set __fish_task_static_dates (printf '%s\n' $__fish_task_static_dates | sed 's/:/\t/' | string collect)
        set __fish_task_static_reldates 'hrs:n hours' \
                                        'day:n days' \
                                        # '1st:first' \
                                        # '2nd:second' \
                                        # '3rd:third' \
                                        # 'th:4th, 5th, etc.' \
                                        'wks:weeks'
        set __fish_task_static_reldates (printf '%s\n' $__fish_task_static_reldates | sed 's/:/\t/' | string collect)
        # the followings are actually not used for autocomplete, but to retrieve friendly description that aren't present in internal command
        set  __fish_task_static_attr_desc_keys 'description' 'status' 'project' \
                                                  'priority' 'due' 'recur' \
                                                  'until' 'limit' 'wait' \
                                                  'entry' 'end' 'start' \
                                                  'scheduled' 'dependson'
        set  __fish_task_static_attr_desc_vals 'Task description text' 'Status of task - pending, completed, deleted, waiting' \
                                                  'Project name' 'Task priority' 'Due date' 'Recurrence frequency' 'Expiration date' \
                                                  'Desired number of rows in report' 'Date until task becomes pending' \
                                                  'Date task was created' 'Date task was completed/deleted' 'Date task was started' \
                                                  'Date task is scheduled to start' 'Other tasks that this task depends upon'

        # fish's auto-completion when multiple `complete` have supplied with '-k' flag, the last will be displayed first
        __fish.task.complete config
        __fish.task.complete context
        __fish.task.complete attr_value
        __fish.task.complete attr_name
        __fish.task.complete tag
        # __fish.task.complete command all
        # __fish.task.complete command filter
        # The following are static so we will expand it when initialised. Display underscore (internal) commands last
        set -l __fish_task_static_commands_underscore (echo -e $__fish_task_static_commands_with_desc | grep '^[_]' | string collect | string escape)
        set -l __fish_task_static_commands_normal (echo -e $__fish_task_static_commands_with_desc | grep '^[^_]' | string collect | string escape)
        complete -c task -u -k -f -n "__fish.task.before_command" -a "$__fish_task_static_commands_underscore"
        complete -c task -u -k -f -n "__fish.task.before_command" -a "$__fish_task_static_commands_normal"

        if [ "$task_complete_task" = 'yes' ]
            __fish.task.complete task
        end

        if [ "$task_complete_id" = 'yes' ]
            __fish.task.complete id with_description
        end

      '';
    }
  ];
}
