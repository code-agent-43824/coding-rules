# Нестыковки и противоречия — на разбор владельцу

Найдено при сверке файлов правил во всех 17 репозиториях `code-agent-43824`
(состояние на 2026-08-11). Пока вопрос не решён, соответствующего правила в
[RULES.md](RULES.md) нет.

Порядок — по убыванию последствий.

---

## 1. Ветки: `main`-only против feature-веток — прямое противоречие

| Проект | Правило |
| --- | --- |
| powermath | «Commit straight to `main`. **Do not create branches** — the owner's explicit instruction» |
| coffee-taster | «Commit directly to `main`. Do not create branches or pull requests» |
| aurora-rutoken | «Единственная рабочая ветка — `main`. Не создавать ветки и pull requests» |
| home-assistant-settings | «Коммитить напрямую в `main`. Не создавать PR и не оставлять висящие ветки» |
| partners-architector | «Commit directly to `main` … **unless the owner asks**» |
| **mobile-wallet-demo** | **«Develop on a feature branch»** — в `AGENTS.md` и продублировано в `.github/copilot-instructions.md` |

`mobile-wallet-demo` противоречит остальным напрямую. Либо это осознанное исключение
(тогда в нём должна стоять причина), либо файл просто отстал от вашего указания.

**Рекомендация:** сделать `main`-only глобальным правилом, а `mobile-wallet-demo`
привести в соответствие. Отдельная причина держать там ветки из документа не видна.

## 2. Обязан ли `main` быть зелёным — прямое противоречие

- `coffee-taster`: «Every push to `main` must leave CI green and produce an installable APK».
- `powermath`: пуш в `main` = деплой в прод, промежуточной среды нет — то есть зелёный CI критичен.
- **`mobile-wallet-demo`: «`main` is **not** required to stay green, but record any breakage and fix forward».**

Вместе с правилом «коммить каждое изменение» это разные модели работы: либо каждый
коммит в `main` обязан быть рабочим, либо допускается временно красный `main`.

**Рекомендация:** требовать зелёный `main` там, где пуш = деплой (powermath,
coffee-taster, mescheryakov-pro-site), и разрешить fix-forward там, где деплой ручной.
Это не одно правило, а правило с явным условием — иначе оно будет нарушаться.

## 3. Есть ли у запрета веток оговорка

`partners-architector` добавляет «unless the owner asks», остальные формулируют
абсолютно. Формально это не конфликт (владелец всегда может отменить своё правило),
но в своде это должно быть сказано один раз и одинаково.

**Вопрос:** оговорка «если владелец явно не попросит» — часть общего правила или нет?

## 4. Канонический файл правил: `AGENTS.md` или `CLAUDE.md`

Две несовместимые схемы:

- **`AGENTS.md` — канон, `CLAUDE.md` — дополнение.** `aurora-rutoken`: «Агент-специфичные
  файлы могут только дополнять его и **не должны дублировать или переопределять** эти
  правила». Так же в `mobile-wallet-demo`.
- **`CLAUDE.md` — единственный источник.** powermath, coffee-taster, 63fz-legal-tech,
  kriptosfera, home-assistant-settings.

Плюс два случая, где схема нарушена в самом проекте:

- `partners-architector` — `CLAUDE.md` **дублирует** hard-constraints из `AGENTS.md`
  (лицензия, запрет деплоя, спека, секреты). Ровно тот дрейф, который запрещает
  правило aurora-rutoken.
- `mobile-wallet-demo` — `.github/copilot-instructions.md` пишет «keep the actual rules
  in `AGENTS.md` to avoid drift» и **тут же пересказывает** рабочее соглашение и
  правило про feature-ветку. Файл нарушает собственное указание.

**Рекомендация:** канон — `AGENTS.md` (его читают и Codex, и Copilot, и Claude Code),
`CLAUDE.md` и `copilot-instructions.md` — только ссылка в одну строку. Иначе правила
будут расходиться в трёх местах.

## 5. Один протокол — семь разных имён файлов

Протокол «документ → код → запись» одинаков везде, а файлы называются по-разному:

| Проект | План | Журнал |
| --- | --- | --- |
| aurora-rutoken | `PLAN.md` | `docs/JOURNAL.md` |
| mobile-wallet-demo | `docs/development-plan.md` | `docs/worklog.md` |
| kriptosfera | `docs/*-plan.md` | `docs/worklog.md` + `CHANGELOG.md` |
| partners-architector | `HANDOFF.md` | `HANDOFF.md` |
| powermath | `docs/STATUS.md` | — |
| 63fz-legal-tech | `docs/PLAN.md` | `docs/PROGRESS.md` |
| coffee-taster | `docs/ROADMAP.md` | — |

Агент, переходящий между проектами, каждый раз ищет файл заново, и в двух проектах
журнала нет вовсе.

**Рекомендация:** закрепить одну пару имён (например `PLAN.md` + `docs/JOURNAL.md`,
как в самом проработанном наборе — aurora-rutoken) и переименовать остальные по мере
касания. Разово ломать 7 репозиториев ради этого не нужно.

## 6. Язык

Разнобой по трём осям:

- **Ответы владельцу по-русски** — сказано только в powermath, coffee-taster,
  home-assistant-settings. В остальных не сказано, хотя вы общаетесь по-русски.
- **Язык документации** — русский (powermath, coffee-taster) против английского
  (partners-architector, kriptosfera, 63fz-legal-tech, mobile-wallet-demo).
- **Язык самих файлов правил** — английский везде, кроме aurora-rutoken и
  home-assistant-settings (русский). powermath формулирует это явно: «Project docs are
  in Russian too; **this file stays in English**».

**Вопрос:** «отвечать по-русски» — глобальное правило? И на каком языке пишутся
доки и сами правила?

Этот свод я написал по-русски (вы читаете его и правите), но если канон — английский,
переведу.

## 7. Формат сообщений коммитов

- Conventional Commits — `kriptosfera`, `mobile-wallet-demo` (наборы префиксов чуть разные:
  `feat/fix/docs/chore/ci` против `feat/fix/docs/refactor/style`).
- «Commit messages in English» — только `coffee-taster`.
- В остальных не сказано ничего.

**Рекомендация:** Conventional Commits + английский язык сообщений глобально —
это уже фактическая практика в половине репозиториев.

## 8. Деплой: полярные позиции

- `powermath`: пуш в `main` **автоматически деплоит в прод**, промежуточной среды нет.
- `coffee-taster`: каждый пуш обязан дать устанавливаемый APK в релизе `latest`.
- `partners-architector`: **агенту деплой запрещён полностью** — только агент Watson,
  и нельзя создавать CI/CD-workflow, deploy-ключи и релизные джобы.
- `mescheryakov-pro-site`: деплой только через `npm run deploy`, `rsync --delete` по
  вебруту запрещён (в вебруте живут чужие проекты).

Это не ошибка — проекты разные. Но глобальное правило должно назвать **умолчание**:
агент деплоит или не деплоит, если в проекте не сказано иного.

**Рекомендация:** умолчание — «агент не деплоит в прод»; автодеплой по пушу считается
явным исключением проекта и пишется в его правилах вместе с последствиями.

## 9. Имя основной ветки — не везде `main`

Правило «коммить в `main`» буквально неприменимо в двух репозиториях:

- `63fz-legal-tech` — основная ветка `master`
- `expense-splitter-flutter` — основная ветка `master`

**Рекомендация:** формулировать правило как «основная ветка репозитория», а эти два
переименовать в `main`, если нет причины держать `master`.

## 10. Семь репозиториев вообще без правил

Ни `CLAUDE.md`, ни `AGENTS.md`, ни `copilot-instructions.md`, ни правил в `README`:

`pdf-signing-demo`, `hardware-encryption-test`, `strongpassword`, `weatherbot`,
`expense-splitter-flutter`, `astralkeytest`, `SoftHSMv2` (форк — вероятно, и не нужно).

Агент, попавший в любой из них, не узнает даже про запрет веток.

**Рекомендация:** положить в каждый короткий `AGENTS.md` со ссылкой на этот свод —
после того, как вы разберёте пункты выше.

## 11. Мелочи

- **Пауза на проверку владельцем.** Только `coffee-taster`: «Pause after each roadmap
  iteration so the owner can check the build on their phone». Полезно как общее правило
  для проектов, где вы проверяете сборку на устройстве, — но нигде больше не записано.
- **Осознанно закоммиченные секреты.** Общий запрет коммитить секреты соседствует с
  двумя намеренными исключениями (`dart_defines.json`, webhook-URL в `.mcp.json`).
  В [RULES.md](RULES.md) §5 я записал это как «исключение допустимо, если оно явно
  зафиксировано с причиной» — это моя трактовка, подтвердите или поправьте.
- **Порядок «сначала коммит плана».** `partners-architector` требует закоммитить
  `HANDOFF.md` **до** касания кода. Остальные допускают запись плана и кода в одном
  изменении. Мелочь, но при «коммить каждое изменение» это разное число коммитов.
