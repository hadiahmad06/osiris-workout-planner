# scraper.py
from playwright.sync_api import sync_playwright
from urllib.parse import urljoin
import json
import hashlib
import re

exercise_data = {}  # Global dictionary for storing exercise data
muscle_data = {}

def normalize(str):
    return re.sub(r'[^a-z0-9]+', '-', str.lower()).strip('-')

def normalize_and_hash_title(str):
    return str
    # DONT NORMALIZE
    # normalized_title = normalize(str)
    # return hashlib.md5(normalized_title.encode()).hexdigest()[:8]

# New functions for scraping exercise and muscle pages
def scrape_exercise_page(page, url):
    page.goto(url, timeout=60000, wait_until="domcontentloaded")
    # print("Scraping exercise page:", url)

    # Extract exercise title from the first <h1>
    title = page.locator("h1").first.text_content()
    if title:
        title = title.strip()
    else:
        title = "N/A"

    short_id = normalize_and_hash_title(title)
    exercise_data[short_id] = {"title": title }#, "hash": short_id}

    # Scrape Muscles section based on <strong> labels in paragraphs followed by <ul>
    roles_to_find = ["Agonist", "Antagonists", "Target", "Synergists", "Stabilizers", "Dynamic Stabilizers", "Antagonist Stabilizers"]
    for role in roles_to_find:
        role_paragraph = page.locator(f"xpath=//p[a/strong[text()='{role}']]")
        if role_paragraph.count() > 0:
            ul = role_paragraph.locator("xpath=following-sibling::ul[1]")
            items = ul.locator("li")
            role_muscles = [
                items.nth(i).text_content().strip()
                for i in range(items.count())
                if items.nth(i).text_content() and items.nth(i).text_content().strip().lower() != "none"
            ]
            exercise_data[short_id][role.lower().replace(" ", "_")] = role_muscles
            for muscle in role_muscles:
                norm = normalize(muscle)
                muscle_data[norm] = {"label": muscle, "id": norm}

    # Scrape related exercises
    related_exercise_links = page.locator("div.ccm-block-page-list-wrapper.thumbnail-page-list a[href]")
    related_exercise_names = []
    for i in range(related_exercise_links.count()):
        name = related_exercise_links.nth(i).text_content()
        if name and name.strip():
            related_exercise_names.append(normalize_and_hash_title(name))
    exercise_data[short_id]["similar_exercises"] = related_exercise_names
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
            elif "../../WeightExercises/" in href and stage == "bodypart":
                full_url = urljoin(base_url, href)
                print("Exercise HREF:", full_url)
                scrape_exercise_page(context.new_page(), full_url)
            # elif "../../Muscles/" in href and stage == "bodypart":
            #     full_url = urljoin(base_url, href)
            #     print("Muscle HREF: ", full_url)
            #     scrape_muscle_page(context.new_page(), full_url)

    page.close()

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    context = browser.new_context(
        user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
    )
    print("Navigating to root directory...")
    # exercise_info = scrape_exercise_page(context.new_page(), "https://exrx.net/WeightExercises/Sternocleidomastoid/CBNeckFlx")
    visit_and_collect_links(context, "https://exrx.net/Lists/Directory", stage="")
    # print(exercise_data)

    # TODO: go through every similar exercise and replace the values with the ids 
    with open("exercise_data.json", "w") as f:
        json.dump(exercise_data, f, indent=1)

    with open("muscle_data.json", "w") as f:
        json.dump(muscle_data, f, indent=1)

    browser.close()