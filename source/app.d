import nice.curses;


struct Point
{
	int x;
	int y;
}


class Dino
{
	const ulong green;
	const ulong blue;

	bool jumping;

	Curses curses;
	Window screen;

	this()
	{
		Curses.Config cfg = {
			useColors: true,
			cursLevel: 0,
		};

		curses = new Curses(cfg);

		screen = curses.stdscr;
		screen.timeout(0);

		jumping = false;

		green = curses.colors[StdColor.green, StdColor.black];
		blue = curses.colors[StdColor.blue, StdColor.black];
	}

	void start()
	{
		while (true)
		{
			try
			{
				const key = screen.getch();

				switch (key)
				{
					case 'q':
						return;
					default:
						break;
				}
			}
			catch (NCException e) {}

			draw();
			refresh();
		}
	}

	void draw()
	{
		screen.clear();

		draw_terrain();
		draw_bush();
		draw_dino();
	}

	void draw_terrain()
	{
		foreach (i; 0 .. screen.width())
		{
			screen.addstr(screen.height - 1, i, "█", green);
		}
	}

	void draw_bush()
	{

	}

	void draw_dino()
	{

	}

	void refresh()
	{
		screen.refresh();
		curses.update();
		curses.nap(500);
	}
}


void main()
{
	auto dino = new Dino;
	dino.start();
}
