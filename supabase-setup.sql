-- Calculadora 3D: tabela onde ficam os dados de cada usuário (modelos, vendas e configurações).
-- Cole tudo no Supabase em: SQL Editor -> New query -> Run.

create table if not exists public.calc_dados (
  user_id uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  dados jsonb not null,
  atualizado_em timestamptz not null default now()
);

-- Cada pessoa só enxerga e altera os próprios dados.
alter table public.calc_dados enable row level security;

drop policy if exists "ler os proprios dados" on public.calc_dados;
drop policy if exists "inserir os proprios dados" on public.calc_dados;
drop policy if exists "atualizar os proprios dados" on public.calc_dados;

create policy "ler os proprios dados" on public.calc_dados
  for select to authenticated using (auth.uid() = user_id);
create policy "inserir os proprios dados" on public.calc_dados
  for insert to authenticated with check (auth.uid() = user_id);
create policy "atualizar os proprios dados" on public.calc_dados
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

grant select, insert, update on public.calc_dados to authenticated;
