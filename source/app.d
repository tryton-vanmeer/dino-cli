import nice.curses;


struct Point
{
	int x;
	int y;
}


struct Colors
{
	ulong green;
	ulong blue;

	this(Curses curses)
	{
		this.green = curses.colors[StdColor.green, StdColor.black];
		this.blue = curses.colors[StdColor.blue, StdColor.black];
	}
}


class Dino
{
	const int TIMER_RANGE = 4;

	int timer;
	bool jumping;

	Curses curses;
	Window screen;
	Colors colors;

	~this()
	{
		destroy(curses);
	}

	this()
	{
		int timer = 0;
		jumping = false;

		Curses.Config cfg = {
			useColors: true,
			cursLevel: 0,
		};

		curses = new Curses(cfg);

		screen = curses.stdscr;
		screen.timeout(60);

		colors = Colors(curses);
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
			screen.addstr(screen.height - 1, i, "█", colors.green);
		}
	}

	void draw_bush()
	{

	}

	void draw_dino()
	{
		auto pos = Point(5, screen.height() - 12);

		screen.addstr(  pos.y, pos.x, "         ▄███████▄", colors.blue);
		screen.addstr(++pos.y, pos.x, "         ██▄██████", colors.blue);
		screen.addstr(++pos.y, pos.x, "         █████████", colors.blue);
		screen.addstr(++pos.y, pos.x, "         ██████▄▄ ", colors.blue);
		screen.addstr(++pos.y, pos.x, "        ██████   ", colors.blue);
		screen.addstr(++pos.y, pos.x, " ▌     ███████▄▄▄", colors.blue);
		screen.addstr(++pos.y, pos.x, " ██▄  ████████  █", colors.blue);
		screen.addstr(++pos.y, pos.x, "  ████████████   ", colors.blue);
		screen.addstr(++pos.y, pos.x, "   █████████     ", colors.blue);

		if (jumping)
		{
			screen.addstr(++pos.y, pos.x, "   ██▄   ██▄", colors.blue);
		}
		else
		{
			screen.addstr(++pos.y, pos.x, "    ██▄ ██  ", colors.blue);
			screen.addstr(++pos.y, pos.x, "         █▄▄  ", colors.blue);
		}
	}

	void refresh()
	{
		screen.refresh();
		curses.update();
	}
}


void main()
{
	auto dino = new Dino;
	dino.start();
	destroy(dino);
}
