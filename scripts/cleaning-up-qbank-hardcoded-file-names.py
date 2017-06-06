# This script is meant to fix a bug introduced by the CLIx authoring
#   tool. Somehow 5 image links are being reported as hardcoded in
#   the field, so they cannot load (still point to MIT production
#   authoring site). This script:
#     1) iterates through all items,
#     2) checks all question text / choices / answer feedbacks
#     3) replaces any instance of "https://qbank-clix.mit.edu..." with
#        the appropriate "AssetContent:<guid>" source instead.
from __future__ import unicode_literals

import re

from bs4 import BeautifulSoup
from pymongo import MongoClient

DLKIT_DATABASES = ['assessment']
COLLECTIONS = ['Item']

MC = MongoClient()

MEDIA_REGEX = re.compile('(https://)')
CURRENT_ID = ''
ITEMS_UPDATED = []
NUM_ITEMS = 0

def grab_matching_asset(source_url, files_map):
    """
    From a given files_map, like {
        <guid>: {
            assetId: "",
            assetContentId: "",
            assetContentTypeId: ""
        }
    }
    We need to return the <guid> corresponding to the
    assetContentId at the end of the source_url.

    source_url format will be
    https://hostname/api/v1/repositories/:id/assets/:id/contents/:id/stream

    We need that last :id to match to the files_map
    """
    if not source_url.endswith('/stream'):
        return None
    asset_content_id = source_url.split('/')[-2]
    for label, asset_map in files_map.items():
        if asset_map['assetContentId'] == asset_content_id:
            return label
    return None

def replace_url_in_display_text(potential_display_text, dict_files_map):
    if ('text' in potential_display_text and
            potential_display_text['text'] is not None and
            'https://' in potential_display_text['text']):
        # assume markup? Wrap this in case it's not a valid XML doc
        # with a single parent object
        wrapped_text = '<wrapper>{0}</wrapper'.format(potential_display_text['text'])
        soup = BeautifulSoup(wrapped_text, 'xml')
        media_file_elements = soup.find_all(src=MEDIA_REGEX)
        media_file_elements += soup.find_all(data=MEDIA_REGEX)
        for media_file_element in media_file_elements:
            print('Found one invalid source in item {0}'.format(CURRENT_ID))
            if 'src' in media_file_element.attrs:
                media_key = 'src'
            else:
                media_key = 'data'

            invalid_source = media_file_element[media_key]

            # Now need to find the label corresponding to this source
            if not invalid_source.endswith('/stream'):
                # this points somewhere else on the Internet? Not a qbank URL
                continue

            media_label = grab_matching_asset(invalid_source, dict_files_map)

            if media_label is not None:
                print('Replaced with AssetContent:{0}'.format(media_label))
                if str(CURRENT_ID) not in ITEMS_UPDATED:
                    ITEMS_UPDATED.append(str(CURRENT_ID))
                media_file_element[media_key] = 'AssetContent:{0}'.format(media_label)
        potential_display_text['text'] = soup.wrapper.renderContents().decode('utf-8')
    else:
        for new_key, value in potential_display_text.items():
            if isinstance(value, list):
                new_files_map = dict_files_map
                if 'fileIds' in potential_display_text:
                    new_files_map = potential_display_text['fileIds']
                potential_display_text[new_key] = check_list_children(value, new_files_map)
    return potential_display_text

def check_list_children(potential_text_list, list_files_map):
    updated_list = []
    for child in potential_text_list:
        if isinstance(child, dict):
            files_map = list_files_map
            if 'fileIds' in child:
                files_map = child['fileIds']
            updated_list.append(replace_url_in_display_text(child, files_map))
        elif isinstance(child, list):
            updated_list.append(check_list_children(child, list_files_map))
        else:
            updated_list.append(child)
    return updated_list


for db_name in DLKIT_DATABASES:
    db = MC[db_name]

    collections = db.collection_names()
    for collection_name in collections:
        if collection_name not in COLLECTIONS:
            continue

        collection = MC[db_name][collection_name]

        for document in collection.find():
            NUM_ITEMS += 1
            CURRENT_ID = str(document['_id'])
            original_files_map = {}
            if 'fileIds' in document:
                original_files_map = document['fileIds']

            for key, data in document.items():
                if isinstance(data, dict):
                    document[key] = replace_url_in_display_text(data, original_files_map)
                elif isinstance(data, list):
                    document[key] = check_list_children(data, original_files_map)
            collection.save(document)

print('Updated {0} items out of {1}'.format(len(ITEMS_UPDATED),
                                            str(NUM_ITEMS)))
print ITEMS_UPDATED
print('Done!')
