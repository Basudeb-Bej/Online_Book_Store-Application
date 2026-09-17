<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Online Book Store</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>
body {
	background: #f5f5f5;
}

/* HERO SECTION */
.hero {
	background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
		url('https://images.unsplash.com/photo-1524995997946-a1c2e315a42f');
	background-size: cover;
	background-position: center;
	height: 90vh;
	color: white;
	display: flex;
	justify-content: center;
	align-items: center;
	text-align: center;
}

.hero h1 {
	font-size: 60px;
	font-weight: bold;
}

.hero p {
	font-size: 20px;
}

/* BOOK CARDS */
.book-card {
	transition: 0.3s;
	border: none;
	border-radius: 15px;
}

.book-card:hover {
	transform: translateY(-10px);
}

.book-img {
	height: 250px;
	object-fit: cover;
}

/* CATEGORY */
.category-card {
	border-radius: 15px;
	transition: 0.3s;
}

.category-card:hover {
	transform: scale(1.05);
}

/* FOOTER */
footer {
	background: #212529;
	color: white;
	padding: 40px 0;
}

/* BOTTOM NAVIGATION */
.bottom-nav {
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	background: white;
	border-top: 1px solid #ddd;
	z-index: 999;
	padding: 10px 0;
}

.bottom-nav a {
	color: #333;
	text-decoration: none;
	font-size: 14px;
}

.bottom-nav i {
	display: block;
	font-size: 20px;
}
</style>

</head>

<body>

	<!-- NAVBAR -->

	<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">

		<div class="container">

			<a class="navbar-brand fw-bold" href="#"> 📚 Online Book Store </a>

			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">

				<span class="navbar-toggler-icon"></span>

			</button>

			<div class="collapse navbar-collapse" id="navbarNav">

				<ul class="navbar-nav ms-auto">

					<li class="nav-item"><a class="nav-link" href="Main-Dashboard.jsp">

							Home </a></li>

					<li class="nav-item"><a class="nav-link" href="books">

							Books </a></li>

					<li class="nav-item"><a class="nav-link" href="jsp/cart.jsp">

							Cart </a></li>

					<li class="nav-item"><a class="nav-link" href="../jsp/login.jsp">
							Login </a></li>

					<li class="nav-item"><a class="btn btn-warning ms-2"
						href="../jsp/register.jsp"> Register </a></li>

				</ul>

			</div>

		</div>

	</nav>

	<!-- HERO SECTION -->

	<section class="hero">

		<div>

			<h1>Discover Your Next Favorite Book</h1>

			<p>Buy books online at the best prices</p>

			<a href="books" class="btn btn-warning btn-lg mt-3"> Browse Books

			</a>

		</div>

	</section>

	<!-- FEATURES -->

	<section class="container py-5">

		<div class="row text-center">

			<div class="col-md-4 mb-4">

				<div class="card shadow p-4">

					<i class="fa-solid fa-truck-fast fa-3x text-primary mb-3"></i>

					<h4>Fast Delivery</h4>

					<p>Get books delivered quickly to your doorstep.</p>

				</div>

			</div>

			<div class="col-md-4 mb-4">

				<div class="card shadow p-4">

					<i class="fa-solid fa-book-open fa-3x text-success mb-3"></i>

					<h4>Huge Collection</h4>

					<p>Thousands of books from every category.</p>

				</div>

			</div>

			<div class="col-md-4 mb-4">

				<div class="card shadow p-4">

					<i class="fa-solid fa-credit-card fa-3x text-danger mb-3"></i>

					<h4>Secure Payment</h4>

					<p>100% secure payment gateway support.</p>

				</div>

			</div>

		</div>

	</section>

	<!-- CATEGORIES -->

	<section class="container py-5">

		<h2 class="text-center mb-5">Book Categories</h2>

		<div class="row">

			<div class="col-md-3 mb-4">

				<div class="card category-card shadow text-center p-4">

					<h4>Programming</h4>

				</div>

			</div>

			<div class="col-md-3 mb-4">

				<div class="card category-card shadow text-center p-4">

					<h4>Science</h4>

				</div>

			</div>

			<div class="col-md-3 mb-4">

				<div class="card category-card shadow text-center p-4">

					<h4>History</h4>

				</div>

			</div>

			<div class="col-md-3 mb-4">

				<div class="card category-card shadow text-center p-4">

					<h4>Fiction</h4>

				</div>

			</div>

		</div>

	</section>

	<!-- FEATURED BOOKS -->

	<section class="container py-5">

		<h2 class="text-center mb-5">Featured Books</h2>

		<div class="row">

			<div class="col-md-3 mb-4">

				<div class="card shadow-lg book-card">

					<img
						src="https://images.unsplash.com/photo-1544947950-fa07a98d237f"
						class="card-img-top book-img">

					<div class="card-body">

						<h5>Java Programming</h5>

						<p>₹ 499</p>

						<a href="books" class="btn btn-primary w-100"> View Details </a>

					</div>

				</div>

			</div>

			<div class="col-md-3 mb-4">

				<div class="card shadow-lg book-card">

					<img
						src="https://images.unsplash.com/photo-1512820790803-83ca734da794"
						class="card-img-top book-img">

					<div class="card-body">

						<h5>Web Development</h5>

						<p>₹ 599</p>

						<a href="books" class="btn btn-primary w-100"> View Details </a>

					</div>

				</div>

			</div>

			<div class="col-md-3 mb-4">

				<div class="card shadow-lg book-card">

					<img
						src="https://images.unsplash.com/photo-1495446815901-a7297e633e8d"
						class="card-img-top book-img">

					<div class="card-body">

						<h5>Data Science</h5>

						<p>₹ 799</p>

						<a href="books" class="btn btn-primary w-100"> View Details </a>

					</div>

				</div>

			</div>

			<div class="col-md-3 mb-4">

				<div class="card shadow-lg book-card">

					<img
						src="https://images.unsplash.com/photo-1521587760476-6c12a4b040da"
						class="card-img-top book-img">

					<div class="card-body">

						<h5>Machine Learning</h5>

						<p>₹ 999</p>

						<a href="books" class="btn btn-primary w-100"> View Details </a>

					</div>

				</div>

			</div>

		</div>

	</section>

	<!-- NEWSLETTER -->

	<section class="bg-dark text-white py-5">

		<div class="container text-center">

			<h2>Subscribe Newsletter</h2>

			<p>Get updates about latest books and offers</p>

			<form class="row justify-content-center">

				<div class="col-md-4">

					<input type="email" class="form-control" placeholder="Enter Email">

				</div>

				<div class="col-md-2">

					<button class="btn btn-warning w-100">Subscribe</button>

				</div>

			</form>

		</div>

	</section>

	<!-- FOOTER -->

	<footer>

		<div class="container">

			<div class="row">

				<div class="col-md-4">

					<h4>About Us</h4>

					<p>Online Book Store is a modern web application for buying
						books online easily.</p>

				</div>

				<div class="col-md-4">

					<h4>Quick Links</h4>

					<ul class="list-unstyled">

						<li><a href="index.jsp"
							class="text-white text-decoration-none"> Home </a></li>

						<li><a href="books" class="text-white text-decoration-none">
								Books </a></li>

						<li><a href="jsp/login.jsp"
							class="text-white text-decoration-none"> Login </a></li>

					</ul>

				</div>

				<div class="col-md-4">

					<h4>Contact</h4>

					<p>📍 Kolkata, India</p>

					<p>📧 support@bookstore.com</p>

					<p>📞 +91 9876543210</p>

				</div>

			</div>

			<hr>

			<p class="text-center">© 2026 Online Book Store</p>

		</div>

	</footer>

	<!-- BOTTOM NAVIGATION -->

	<div class="bottom-nav d-md-none">

		<div class="container">

			<div class="row text-center">

				<div class="col">

					<a href="index.jsp"> <i class="fa-solid fa-house"></i> Home

					</a>

				</div>

				<div class="col">

					<a href="books"> <i class="fa-solid fa-book"></i> Books

					</a>

				</div>

				<div class="col">

					<a href="jsp/cart.jsp"> <i class="fa-solid fa-cart-shopping"></i>

						Cart

					</a>

				</div>

				<div class="col">

					<a href="jsp/login.jsp"> <i class="fa-solid fa-user"></i> Login

					</a>

				</div>

			</div>

		</div>

	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
		
	</script>

</body>
</html>