{
  home,
  pkgs,
  config,
  ...
}: {
  programs.taskwarrior = {
    enable = true;
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

      taskd = {
        certificate = "~/.task/voile.bcraton.cert.pem";
        # TODO: This should be a secret
        key = "~/.task/voile.bcraton.key.pem";
        ca = "~/.task/voile.ca.pem";
        server = "voile.armadillo-banfish.ts.net:53589";
        credentials = "Falseblue/Ben Craton/309bdd58-1026-4213-83d4-ad92e085ac92";
        trust = "ignore hostname";
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
  services.taskwarrior-sync =
    if pkgs.stdenv.isLinux
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
  };

  home.file.".task/voile.bcraton.cert.pem".path = config.sops.secrets."taskwarrior/user-cert".path;
  home.file.".task/voile.bcraton.key.pem".path = config.sops.secrets."taskwarrior/user-key".path;

  home.file.".task/voile.ca.pem".text = ''
    -----BEGIN CERTIFICATE-----
    MIIFjjCCA3agAwIBAgIUY3e3WdfYvpKfKY+Ymc/fDw4/GBswDQYJKoZIhvcNAQEM
    BQAwXzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAklOMRIwEAYDVQQHEwlMYWZheWV0
    dGUxEjAQBgNVBAoTCUZhbHNlQmx1ZTEbMBkGA1UEAxMSdGFzay5mYWxzZWJsdWUu
    Y29tMB4XDTI0MDEyNTA0NDgzOFoXDTI1MDEyNDA0NDgzOFowXzELMAkGA1UEBhMC
    VVMxCzAJBgNVBAgTAklOMRIwEAYDVQQHEwlMYWZheWV0dGUxEjAQBgNVBAoTCUZh
    bHNlQmx1ZTEbMBkGA1UEAxMSdGFzay5mYWxzZWJsdWUuY29tMIICIjANBgkqhkiG
    9w0BAQEFAAOCAg8AMIICCgKCAgEA7txLsxOKl6dI82ut/Uxi0dT9Jo709st1MzDe
    C5dBo5PK24zz8CSVraMoFEleGCtNYTciVuNqTpoOstVVJI+7dH328E5XxGgFmqow
    x3bDx84AB2b1aiBvwYPg3EUeb0Z4JSXayw7EXkgzJ4VZUVSBEQqpXKACJ9okhenA
    D1Z6725mQu+nm69k070uH+WlWBXOLrFY5Defni94VV/DZT0pb1xugVny1STIZAOk
    fbkh7e+NCKyofN1DXiOjUqmJH0j6O2nHmG4shCufHhCpcNy0j0JRDCKjf0P6yCZ3
    6TOTFCl9Soko3uLCOXYpzQmAdnqbPYLtIry8jvtC881n6g+eGOWFlWNLJ3wb3w8C
    r31i+QHlHjB0OlOVmP63a06vEjWWVyLf+bjP9+3PscyDCivq0ef2P1eSAl9vjITS
    HbZ/kUQLo8EffO1AqYQhzDRRDrBNHY7lf5u1HHCKsy+vYs0ZHWvbQjStwULfPeAU
    sQWTsR1c2uHIZKFyX8eoGR/IEck8Dokm/kTYHjK0pDnZh6KIh7WMEXM68idNrHrK
    ZBcVnTPSl/rDCn2LOuOQE+eKrvl20SMz1U7D7ms4mDzMauDq6pdvTjnrCu4hhzwv
    Dt6JA3WmixHw+8Hr+iWor9Cmp8sFU7GCOGW1VxEzaeEyFePZDDEYWhVvlcfwRSHO
    EOaaiC0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAgQw
    HQYDVR0OBBYEFMjE91/NAB4fj+Fu4FYcU7VQm+2jMA0GCSqGSIb3DQEBDAUAA4IC
    AQCFEnB5x5K2tB8GQPq58Dsk0lL2WqA+K6rz+Gu7yHn4grC8EQP5VsAF/FJAgQq5
    OAmSyP9l3RgkyzF5f80rcKEIo+f4v/IR329HcSgZ6wU+NP8gBEPKIrgE73ztL9+B
    j1s2fN1ENEv2vB4WX3sO9kz9kZREEeUXDji0ARukzRjq93sPD8KBmd9Up0xtTOOX
    RJcotJp9a6W3vVPJ1S1vZL+OkAsdLuft0OKFNoWxbxQe0st6rz+3ecAuwZ2KLLb1
    q+5g6PEcNCD5unD+KSSElIASJL1CPF2p/T6f8zglvm5lp9DNCxmsXFzZZXmwhsse
    +U2kXbZBybMGaCbSh0z5C/nIR+avwuABrd2amjiAjyuuX6D4quDYcTW8BX7k8Gel
    CwdUO7eko25VVuU9VrxkVWUHPw1h7bliz4F6iaP1NlUaTFA5qaW83M6T/3v60ZJY
    8ZJnTtIvsemjdQ+cVRRt4AyVIVC4SHIkwxDmsP6D1L2R0Lu9Cc+rqq1ql7m1xfjt
    jI9I1msmNgMlqB/VNUWrqG5NkKa4tqj2JqQMcsjeXZUA17WihVT3IddunODvvxPO
    IGK22TgZlmpdEar6zVtkmQGsqHcEh+ipf2gaD/5gxPzsyS372j3fi2ByoS1qM3UR
    RILvT4TcM9C1me7Bgq1l3/bBpjHak72F8bP8ABtQRKGp1A==
    -----END CERTIFICATE-----
  '';
}
