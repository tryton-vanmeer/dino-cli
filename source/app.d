import std.random;
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
	int bush_pos;
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
		timer = 0;
		bush_pos = -10;
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
			timer = (timer >= TIMER_RANGE ? 0 : timer + 1);

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
		bush_pos -= 3;

		if (bush_pos <= -5)
		{
			const rand = Random(timer);
			bush_pos = screen.width() + (rand.front() % screen.width());
		}

		if (bush_pos <= (screen.width() -5))
		{
			const y = screen.height() - 1;

			try
			{
				screen.addstr(y - 4, bush_pos, "▄█ █▄", colors.green);
				screen.addstr(y - 3, bush_pos, "██ ██", colors.green);
				screen.addstr(y - 2, bush_pos + 1, "███", colors.green);
				screen.addstr(y - 1, bush_pos + 1, "███", colors.green);
			}
			catch (NCException e) {}
		}
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
			if (timer < (TIMER_RANGE / 2))
			{
				screen.addstr(++pos.y, pos.x, "   ██    ██▄   ", colors.blue);
				screen.addstr(++pos.y, pos.x, "   █▄▄      ", colors.blue);
			}
			else
			{
				screen.addstr(++pos.y, pos.x, "    ██▄ ██  ", colors.blue);
				screen.addstr(++pos.y, pos.x, "         █▄▄  ", colors.blue);
			}
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
