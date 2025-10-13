import React, { useState, useContext, createContext } from 'react';

// Zepto-like simple single-file React app for learning purposes
// Tailwind CSS utility classes are used for styling (no colors hard-coded).
// To run: create a React project (create-react-app), add Tailwind, then replace App.jsx with this file.

// -------- Sample Data --------
const PRODUCTS = [
  { id: 1, name: 'Fresh Bananas (1kg)', price: 60, img: 'https://via.placeholder.com/240x160?text=Bananas' },
  { id: 2, name: 'Whole Wheat Bread', price: 40, img: 'https://via.placeholder.com/240x160?text=Bread' },
  { id: 3, name: 'Organic Milk (1L)', price: 70, img: 'https://via.placeholder.com/240x160?text=Milk' },
  { id: 4, name: 'Brown Eggs (6 pcs)', price: 90, img: 'https://via.placeholder.com/240x160?text=Eggs' },
  { id: 5, name: 'Tomatoes (1kg)', price: 55, img: 'https://via.placeholder.com/240x160?text=Tomatoes' }
];

// -------- Cart Context --------
const CartContext = createContext();
function useCart() { return useContext(CartContext); }

function CartProvider({ children }) {
  const [items, setItems] = useState([]);

  function addToCart(product, qty = 1) {
    setItems(prev => {
      const found = prev.find(i => i.id === product.id);
      if (found) return prev.map(i => i.id === product.id ? { ...i, qty: i.qty + qty } : i);
      return [...prev, { ...product, qty }];
    });
  }

  function removeFromCart(id) {
    setItems(prev => prev.filter(i => i.id !== id));
  }

  function updateQty(id, qty) {
    if (qty <= 0) return removeFromCart(id);
    setItems(prev => prev.map(i => i.id === id ? { ...i, qty } : i));
  }

  function clearCart() { setItems([]); }

  const subtotal = items.reduce((s, it) => s + it.price * it.qty, 0);

  return (
    <CartContext.Provider value={{ items, addToCart, removeFromCart, updateQty, clearCart, subtotal }}>
      {children}
    </CartContext.Provider>
  );
}

// -------- UI Components --------
function Header({ onNavigate }) {
  const { items } = useCart();
  const totalCount = items.reduce((s, i) => s + i.qty, 0);
  return (
    <header className="bg-white shadow sticky top-0 z-10">
      <div className="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <div className="text-2xl font-bold cursor-pointer" onClick={() => onNavigate('home')}>Zepto-Lite</div>
          <nav className="hidden md:flex gap-3 text-sm text-gray-600">
            <button onClick={() => onNavigate('home')} className="hover:underline">Home</button>
            <button onClick={() => onNavigate('products')} className="hover:underline">Shop</button>
            <button onClick={() => onNavigate('contact')} className="hover:underline">Contact</button>
          </nav>
        </div>

        <div className="flex items-center gap-4">
          <div className="hidden md:block text-sm text-gray-600">Fast delivery in your area</div>
          <button onClick={() => onNavigate('cart')} className="relative">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4" />
            </svg>
            {totalCount > 0 && <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full px-2">{totalCount}</span>}
          </button>
        </div>
      </div>
    </header>
  );
}

function Footer() {
  return (
    <footer className="bg-gray-50 border-t mt-8">
      <div className="max-w-6xl mx-auto px-4 py-6 text-sm text-gray-600">© {new Date().getFullYear()} Zepto-Lite • For learning purpose only</div>
    </footer>
  );
}

function Hero({ onNavigate }) {
  return (
    <section className="bg-gradient-to-r from-gray-50 to-white py-12">
      <div className="max-w-6xl mx-auto px-4 grid md:grid-cols-2 gap-8 items-center">
        <div>
          <h1 className="text-3xl md:text-4xl font-bold mb-4">Grocery delivered to your door in minutes</h1>
          <p className="text-gray-600 mb-6">Shop fresh fruits, essentials and daily groceries. Fast delivery, great prices.</p>
          <div className="flex gap-3">
            <button onClick={() => onNavigate('products')} className="px-4 py-2 rounded shadow">Shop now</button>
            <button onClick={() => onNavigate('contact')} className="px-4 py-2 rounded border">Contact us</button>
          </div>
        </div>
        <div className="flex justify-center">
          <img src="https://via.placeholder.com/520x320?text=Groceries" alt="groceries" className="rounded shadow" />
        </div>
      </div>
    </section>
  );
}

function ProductCard({ product, onView }) {
  const { addToCart } = useCart();
  return (
    <div className="border rounded p-3 flex flex-col">
      <img src={product.img} alt={product.name} className="h-40 object-cover rounded mb-3" />
      <div className="flex-1">
        <h3 className="font-semibold">{product.name}</h3>
        <p className="text-gray-600">₹{product.price}</p>
      </div>
      <div className="mt-3 flex gap-2">
        <button onClick={() => addToCart(product)} className="flex-1 py-2 rounded bg-green-50">Add</button>
        <button onClick={() => onView(product)} className="py-2 px-3 rounded border">View</button>
      </div>
    </div>
  );
}

function ProductsPage({ onNavigate }) {
  const [query, setQuery] = useState('');
  const filtered = PRODUCTS.filter(p => p.name.toLowerCase().includes(query.toLowerCase()));

  function view(p) { onNavigate('product', p); }

  return (
    <main className="max-w-6xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-xl font-bold">Shop</h2>
        <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Search products" className="border rounded px-3 py-2" />
      </div>
      <div className="grid sm:grid-cols-2 md:grid-cols-3 gap-4">
        {filtered.map(p => <ProductCard key={p.id} product={p} onView={view} />)}
      </div>
    </main>
  );
}

function ProductDetail({ product, onNavigate }) {
  const { addToCart } = useCart();
  if (!product) return <div className="p-8">No product selected.</div>;

  return (
    <main className="max-w-4xl mx-auto px-4 py-8">
      <div className="grid md:grid-cols-2 gap-6">
        <img src={product.img} alt={product.name} className="rounded shadow" />
        <div>
          <h2 className="text-2xl font-bold mb-2">{product.name}</h2>
          <p className="text-gray-600 mb-4">Price: ₹{product.price}</p>
          <p className="mb-6">Fresh and quality-assured product for daily use.</p>
          <div className="flex gap-3">
            <button onClick={() => addToCart(product)} className="py-2 px-4 rounded bg-green-50">Add to cart</button>
            <button onClick={() => onNavigate('products')} className="py-2 px-4 rounded border">Back to shop</button>
          </div>
        </div>
      </div>
    </main>
  );
}

function CartPage({ onNavigate }) {
  const { items, updateQty, removeFromCart, subtotal, clearCart } = useCart();

  return (
    <main className="max-w-4xl mx-auto px-4 py-8">
      <h2 className="text-xl font-bold mb-4">Your Cart</h2>
      {items.length === 0 ? (
        <div className="p-6 border rounded">Your cart is empty. <button onClick={() => onNavigate('products')} className="ml-2 text-blue-600">Shop now</button></div>
      ) : (
        <div className="grid md:grid-cols-2 gap-6">
          <div>
            {items.map(it => (
              <div key={it.id} className="flex items-center gap-4 border-b py-3">
                <img src={it.img} alt={it.name} className="w-20 h-20 object-cover rounded" />
                <div className="flex-1">
                  <div className="font-semibold">{it.name}</div>
                  <div className="text-sm text-gray-600">₹{it.price} x {it.qty} = ₹{it.price * it.qty}</div>
                </div>
                <div className="flex items-center gap-2">
                  <button onClick={() => updateQty(it.id, it.qty - 1)} className="px-2 py-1 border rounded">-</button>
                  <div className="px-3">{it.qty}</div>
                  <button onClick={() => updateQty(it.id, it.qty + 1)} className="px-2 py-1 border rounded">+</button>
                  <button onClick={() => removeFromCart(it.id)} className="ml-2 text-red-600">Remove</button>
                </div>
              </div>
            ))}
          </div>

          <aside className="border rounded p-4">
            <div className="mb-4">Subtotal: <strong>₹{subtotal}</strong></div>
            <button onClick={() => onNavigate('checkout')} className="w-full py-2 rounded">Proceed to checkout</button>
            <button onClick={clearCart} className="w-full mt-2 py-2 rounded border">Clear cart</button>
          </aside>
        </div>
      )}
    </main>
  );
}

function CheckoutPage({ onNavigate }) {
  const { items, subtotal, clearCart } = useCart();
  const [name, setName] = useState('');
  const [address, setAddress] = useState('');
  const [placed, setPlaced] = useState(false);

  function placeOrder(e) {
    e.preventDefault();
    // For learning: simulate order placement
    setPlaced(true);
    clearCart();
  }

  if (placed) return (
    <main className="max-w-3xl mx-auto px-4 py-8">
      <div className="p-6 border rounded text-center">
        <h3 className="text-xl font-bold">Order placed!</h3>
        <p className="mt-2">Thank you, {name}. Your groceries will arrive soon.</p>
        <button onClick={() => onNavigate('home')} className="mt-4 py-2 px-4 rounded">Back to home</button>
      </div>
    </main>
  );

  return (
    <main className="max-w-3xl mx-auto px-4 py-8">
      <h2 className="text-xl font-bold mb-4">Checkout</h2>
      <form onSubmit={placeOrder} className="space-y-4">
        <div>
          <label className="block text-sm">Name</label>
          <input required value={name} onChange={e => setName(e.target.value)} className="w-full border rounded px-3 py-2" />
        </div>
        <div>
          <label className="block text-sm">Delivery address</label>
          <textarea required value={address} onChange={e => setAddress(e.target.value)} className="w-full border rounded px-3 py-2" />
        </div>
        <div>Order total: <strong>₹{subtotal}</strong></div>
        <div className="flex gap-2">
          <button type="submit" className="py-2 px-4 rounded">Place order</button>
          <button type="button" onClick={() => onNavigate('cart')} className="py-2 px-4 rounded border">Back to cart</button>
        </div>
      </form>
    </main>
  );
}

function ContactPage() {
  const [msg, setMsg] = useState('');
  function send(e) { e.preventDefault(); alert('Message sent (demo)'); setMsg(''); }
  return (
    <main className="max-w-3xl mx-auto px-4 py-8">
      <h2 className="text-xl font-bold mb-4">Contact us</h2>
      <form onSubmit={send} className="space-y-4">
        <div>
          <label className="block text-sm">Message</label>
          <textarea required value={msg} onChange={e => setMsg(e.target.value)} className="w-full border rounded px-3 py-2" />
        </div>
        <div>
          <button className="py-2 px-4 rounded">Send</button>
        </div>
      </form>
    </main>
  );
}

// -------- App (simple client-side 'router' for a single-file demo) --------
export default function App() {
  const [route, setRoute] = useState({ name: 'home', data: null });

  function navigate(name, data = null) {
    setRoute({ name, data });
    window.scrollTo(0, 0);
  }

  return (
    <CartProvider>
      <div className="min-h-screen flex flex-col">
        <Header onNavigate={r => navigate(r)} />

        <div className="flex-1">
          {route.name === 'home' && (
            <>
              <Hero onNavigate={navigate} />
              <div className="max-w-6xl mx-auto px-4 py-8">
                <h3 className="text-xl font-semibold mb-4">Popular items</h3>
                <div className="grid sm:grid-cols-2 md:grid-cols-3 gap-4">
                  {PRODUCTS.map(p => <ProductCard key={p.id} product={p} onView={(prod) => navigate('product', prod)} />)}
                </div>
              </div>
            </>
          )}

          {route.name === 'products' && <ProductsPage onNavigate={navigate} />}
          {route.name === 'product' && <ProductDetail product={route.data} onNavigate={navigate} />}
          {route.name === 'cart' && <CartPage onNavigate={navigate} />}
          {route.name === 'checkout' && <CheckoutPage onNavigate={navigate} />}
          {route.name === 'contact' && <ContactPage />}
        </div>

        <Footer />
      </div>
    </CartProvider>
  );
}

