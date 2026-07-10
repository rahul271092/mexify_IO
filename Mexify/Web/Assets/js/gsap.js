// MEXIFY GSAP ScrollTrigger Animations
document.addEventListener('DOMContentLoaded', () => {
    gsap.registerPlugin(ScrollTrigger);

    // Header Scroll Effect
    ScrollTrigger.create({
        start: "top -80",
        onUpdate: (self) => {
            const header = document.querySelector('.main-header');
            if (self.direction === 1 && self.progress > 0) {
                header.classList.add('scrolled');
            } else if (self.progress === 0) {
                header.classList.remove('scrolled');
            }
        }
    });

    // Parallax Hero Text
    gsap.to(".hero-title", {
        yPercent: -30,
        ease: "none",
        scrollTrigger: {
            trigger: ".hero-section",
            start: "top top",
            end: "bottom top",
            scrub: true
        }
    });

    // Staggered Feature Cards
    gsap.utils.toArray('.glass-card').forEach((card, i) => {
        gsap.from(card, {
            scrollTrigger: {
                trigger: card,
                start: "top 85%",
                toggleActions: "play none none none"
            },
            y: 50,
            opacity: 0,
            duration: 0.8,
            delay: i * 0.1,
            ease: "power3.out"
        });
    });
});