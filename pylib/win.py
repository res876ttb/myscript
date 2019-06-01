import curses, atexit

lineno = 0
win = curses.initscr()

def tear_down():
  global win
  win.keypad(0)
  curses.nocbreak()
  curses.echo()
  curses.endwin()

def print(line, highlight=False):
  global lineno
  if '\n' in line:
    lines = line.split('\n')
  else:
    lines = [line]
  for line in lines:
    try:
      if highlight:
        line += ' ' * win.getmaxyx()[1] - len(line)
        win.addstr(lineno, 0, line, curses.A_REVERSE)
      else:
        win.addstr(lineno, 0, line, 0)
    except curses.error:
      lineno = 0
      win.refresh()
      raise
    else:
      lineno += 1

def init():
  global lineno
  atexit.register(tear_down)
  curses.endwin()
  lineno = 0

def refresh():
  win.refresh()

def flush():
  global lineno
  win.refresh()
  lineno = 0

