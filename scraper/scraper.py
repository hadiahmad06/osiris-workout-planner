# scraper.py
from playwright.sync_api import sync_playwright
from urllib.parse import urljoin


# New functions for scraping exercise and muscle pages
def scrape_exercise_page(page, url):
    page.goto(url, timeout=60000)
    print("Scraping exercise page:", url)
    # TODO: Add specific scraping logic here
    page.close()

def scrape_muscle_page(page, url):
    page.goto(url, timeout=60000)
    print("Scraping muscle page:", url)
    # TODO: Add specific scraping logic here
    page.close()

def visit_and_collect_links(context, base_url, stage=""):
    page = context.new_page()
    page.goto(base_url, timeout=60000)

    links = page.locator("a[href]:visible").all()
    for link in links:
        href = link.get_attribute("href")
        if href and "#" not in href:
            if href.startswith("ExList/") and stage == "":
                full_url = "https://exrx.net/Lists/" + href
                print("Body Part HREF: ", full_url)
                visit_and_collect_links(context, full_url, stage="bodypart")
                break  # only visit the first body part link temporarily
            elif "../../WeightExercises/" in href and stage == "bodypart":
                full_url = urljoin(base_url, href)
                print("Exercise HREF:", full_url)
                scrape_exercise_page(context.new_page(), full_url)
            elif "../../Muscles/" in href and stage == "bodypart":
                full_url = urljoin(base_url, href)
                print("Muscle HREF: ", full_url)
                scrape_muscle_page(context.new_page(), full_url)

    page.close()

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    context = browser.new_context(
        user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
    )
    print("Navigating to root directory...")
    visit_and_collect_links(context, "https://exrx.net/Lists/Directory", stage="")

    browser.close()