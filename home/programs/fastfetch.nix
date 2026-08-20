{ ... }:
{
  programs = {
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
          padding = {
            right = 1;
            top = 2;
          };
        };
        display = {
          size = {
            binaryPrefix = "si";
          };
          color = "blue";
          separator = " ";
        };
        modules = [
          {
            "key" = "╭─────────────────╮";
            "type" = "custom";
          }
          {
            "key" = "│ {#36} User          {#keys}│";
            "type" = "title";
            "format" = "{user-name}";
          }
          {
            "key" = "│ {#36} Hostname      {#keys}│";
            "type" = "title";
            "format" = "{host-name}";
          }
          {
            "key" = "│ {#36} Uptime        {#keys}│";
            "type" = "uptime";
          }
          {
            "key" = "│ {#36} Distro        {#keys}│";
            "type" = "os";
          }
          {
            "key" = "│ {#36} Kernel        {#keys}│";
            "type" = "kernel";
          }
          {
            "key" = "│ {#36} Packages      {#keys}│";
            "type" = "packages";
          }
          {
            "key" = "│ {#36} Icons         {#keys}│";
            "type" = "icons";
          }
          {
            "key" = "│ {#36} Font          {#keys}│";
            "type" = "font";
          }
          {
            "key" = "│ {#36} Cursor        {#keys}│";
            "type" = "cursor";
          }
          {
            "key" = "│ {#36} Terminal      {#keys}│";
            "type" = "terminal";
          }
          {
            "key" = "│ {#36} Terminal Font {#keys}│";
            "type" = "terminalfont";
          }
          {
            "key" = "│ {#36} Resolution    {#keys}│";
            "type" = "display";
            "compactType" = "original-with-refresh-rate";
          }
          {
            "key" = "│ {#36} Shell         {#keys}│";
            "type" = "shell";
          }
          {
            "key" = "│ {#36} WM            {#keys}│";
            "type" = "wm";
          }
          {
            "key" = "│ {#36} CPU           {#keys}│";
            "type" = "cpu";
            "showPeCoreCount" = true;
          }
          {
            "key" = "│ {#36} GPU           {#keys}│";
            "type" = "gpu";
            "showPeCoreCount" = true;
          }
          {
            "key" = "│ {#36} Disk          {#keys}│";
            "type" = "disk";
          }
          {
            "key" = "│ {#36} Memory        {#keys}│";
            "type" = "memory";
          }
          {
            "key" = "│ {#36} Battery       {#keys}│";
            "type" = "battery";
            "temp" = true;
          }
          {
            "key" = "│ {#36} Local IP      {#keys}│";
            "type" = "localip";
          }
          {
            "key" = "│ {#36} Public IP     {#keys}│";
            "type" = "publicip";
            "timeout" = 1000;
          }
          {
            "key" = "├─────────────────┤";
            "type" = "custom";
          }
          {
            "key" = "│ {#39} Colors        {#keys}│";
            "type" = "colors";
            "symbol" = "circle";
          }
          {
            "key" = "╰─────────────────╯";
            "type" = "custom";
          }
          "break"
        ];
      };
    };
  };
}
