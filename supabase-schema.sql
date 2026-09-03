create table public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text not null default '',
  price numeric(10,2) not null check (price >= 0),
  category text not null check (category in ('marmitas', 'especiais', 'sobremesas', 'bebidas')),
  image_url text,
  emoji text not null default '🍽️',
  badge text,
  sale_price numeric(10,2) check (sale_price is null or sale_price >= 0),
  is_available boolean not null default true,
  is_published boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;

create policy "Anyone can read published products"
on public.products for select
using (is_published = true and is_available = true);

create policy "Authenticated admins can read all products"
on public.products for select to authenticated
using (true);

create policy "Authenticated admins can insert products"
on public.products for insert to authenticated
with check (true);

create policy "Authenticated admins can update products"
on public.products for update to authenticated
using (true) with check (true);

create policy "Authenticated admins can delete products"
on public.products for delete to authenticated
using (true);

insert into public.products (name, description, price, category, image_url, emoji, is_published, is_available, sort_order) values
('Carne na Chapa', 'Carne, arroz, farofa, maionese, vatapá, queijo, banana e abacaxi.', 30, 'marmitas', '/imagens/carne.jpeg', '🥩', true, true, 1),
('Macarronese', 'Macarrão, frango desfiado, maionese, verduras e presunto.', 20, 'especiais', '/imagens/macarronese.jpeg', '🍝', true, true, 1),
('Mousse de Maracujá', 'Sobremesa cremosa e refrescante.', 8, 'sobremesas', '/imagens/mousse1.jpeg', '🥭', true, true, 1),
('Mousse de Cupuaçu', 'Um sabor amazônico cremoso para finalizar sua refeição.', 8, 'sobremesas', '/imagens/mousse2.jpeg', '🌴', true, true, 2),
('Suco Natural de Cupuaçu', 'Suco natural, geladinho e cheio de sabor.', 12, 'bebidas', '/imagens/cardapio.jpeg', '🧃', true, true, 1),
('Suco Natural de Maracujá', 'Suco natural, geladinho e cheio de sabor.', 12, 'bebidas', '/imagens/cardapio.jpeg', '🧃', true, true, 2);
