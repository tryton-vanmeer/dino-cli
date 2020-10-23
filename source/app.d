import std.random;
import nice.curses;


struct Point
{
	int x;
	int y;
}


struct ColorCfg
{
	ulong dino;
	ulong terrain;
	ulong bush;
}


class Dino
{
	const int TIMER_RANGE = 4;

	int timer = 0;
	int bush_pos = -10;
	bool jumping = false;
	int jump_timer = 0;

	ColorCfg colors;

	Curses curses;
	Window screen;

	~this()
	{
		destroy(curses);
	}

	this()
	{
		Curses.Config cfg = {
			useColors: true,
			cursLevel: 0,
		};

		curses = new Curses(cfg);

		screen = curses.stdscr;
		screen.timeout(60);

		colors.dino = curses.colors[StdColor.blue, StdColor.black];
		colors.terrain = curses.colors[StdColor.green, StdColor.black];
		colors.bush = curses.colors[StdColor.green, StdColor.black];
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

	void jump()
	{
		jumping = true;
		jump_timer = cast(int) (TIMER_RANGE * 2.4);
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
			screen.addstr(screen.height - 1, i, "█", colors.terrain);
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
				screen.addstr(y - 4, bush_pos, "▄█ █▄", colors.bush);
				screen.addstr(y - 3, bush_pos, "██ ██", colors.bush);
				screen.addstr(y - 2, bush_pos + 1, "███", colors.bush);
				screen.addstr(y - 1, bush_pos + 1, "███", colors.bush);
			}
			catch (NCException e) {}
		}
	}

	void draw_dino()
	{
		auto pos = Point(5, screen.height() - 12);

		if (jumping)
		{
			pos.y -= 4;
			jump_timer--;

			if (jump_timer <= 0)
			{
				jumping = false;
			}
		}

		screen.addstr(  pos.y, pos.x, "         ▄███████▄", colors.dino);
		screen.addstr(++pos.y, pos.x, "         ██▄██████", colors.dino);
		screen.addstr(++pos.y, pos.x, "         █████████", colors.dino);
		screen.addstr(++pos.y, pos.x, "         ██████▄▄ ", colors.dino);
		screen.addstr(++pos.y, pos.x, "        ██████   ", colors.dino);
		screen.addstr(++pos.y, pos.x, " ▌     ███████▄▄▄", colors.dino);
		screen.addstr(++pos.y, pos.x, " ██▄  ████████  █", colors.dino);
		screen.addstr(++pos.y, pos.x, "  ████████████   ", colors.dino);
		screen.addstr(++pos.y, pos.x, "   █████████     ", colors.dino);

		if (jumping)
		{
			screen.addstr(++pos.y, pos.x, "   ██▄   ██▄", colors.dino);
		}
		else
		{
			if (timer < (TIMER_RANGE / 2))
			{
				screen.addstr(++pos.y, pos.x, "   ██    ██▄   ", colors.dino);
				screen.addstr(++pos.y, pos.x, "   █▄▄      ", colors.dino);
			}
			else
			{
				screen.addstr(++pos.y, pos.x, "    ██▄ ██  ", colors.dino);
				screen.addstr(++pos.y, pos.x, "         █▄▄  ", colors.dino);
			}
		}

		if (bush_pos < 23 && bush_pos > 10 && !jumping)
		{
			jump();
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
	auto dino = new Dino();
	dino.start();
	destroy(dino);
}
